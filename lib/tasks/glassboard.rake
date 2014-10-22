require 'nokogiri'
require 'pathname'
require 'json'

namespace :glassboard do
  task convert: :environment do
    nodes = []

    Dir.chdir("gb") do
      page = Nokogiri::HTML(open("index.html"))

      divList = page.xpath("//div[contains(@class, 'statusDiv') or contains(@class, 'commentDiv')]")

      print "reading in nodes..."
      divList.each do |div|
        node = Node.new(div)

        if node.is_status?
          nodes << node
        else
          nodes.last.add_node(node)
        end
      end
      print "done count: #{nodes.count}\n"
    end

    print "dumping nodes to family.json..."
    File.open("family.json", "w") do |f|
      nodes.each do |n|
        f.puts GPost.new(n).to_json
      end
    end
    print "done\n"
  end

  task posts: :environment do
    ActiveRecord::Base.record_timestamps = false

    File.open("family.json", "r").each do |data|
      # pp data
      json = JSON.parse(data)
      # pp json

      if Post.exists?(json["id"])
        pp "Post: #{json['id']} exists already...skipping"
      else
        post = build_post(json)
        pp "Post: #{post.id} created"
      end
    end

    print_stats
  end

  task photos: :environment do
    ActiveRecord::Base.record_timestamps = false

    File.open("family.json", "r").each do |data|
      json = JSON.parse(data)
      # post = Post.find(json["id"])
      upload_photo json
    end

    print_stats
  end

  task dump_text: :environment do
    ActiveRecord::Base.record_timestamps = false

    print "dumping nodes to family.txt..."
    File.open("family.txt", "w") do |out|
      File.open("family.json", "r").each do |data|
        json = JSON.parse(data)
        out.puts json["content"]
        json["comments"].each do |comment_json|
          out.puts comment_json["content"]
        end
      end
    end
  end
end

def print_stats
  pp "----------------------------"
  pp "Users   : #{User.count}"
  pp "Posts   : #{Post.count}"
  pp "Comments: #{Comment.count}"
  pp "Hearts  : #{Heart.count}"
  pp "Photos  : #{Photo.count}"
end

def build_post json
  user = User.find(json["user"])
  post = user.posts.build(
    {
      content: json["content"],
      created_at: json["posted_on"],
      updated_at: json["posted_on"]
    }
  )

  if json["location"]
    post.latitude = json["location"].split(",").first
    post.longitude = json["location"].split(",").last
  end

  post.id = json["id"]
  post.save!

  build_comments(post, json["comments"])
  build_the_love(post, json["likes"])
  build_photo(post, json["image"])
  post
end

def build_comments post, comments
  return unless comments
  comments.each do |json|
    next if Comment.exists?(json["id"])

    comment = post.comments.build(
      {
        user_id: json["user"],
        content: json["content"],
        created_at: json["posted_on"],
        updated_at: json["posted_on"]
      }
    )

    if json["location"]
      comment.latitude = json["location"].split(",").first
      comment.longitude = json["location"].split(",").last
    end

    comment.id = json["id"]
    comment.save!

    build_the_love(comment, json["likes"])
    build_photo(comment, json["image"])
  end
end

def build_the_love(model, likes)
  return unless likes
  likes.each do |user_id|
    heart = model.hearts.build
    heart.user_id = user_id
    heart.created_at = model.created_at
    heart.updated_at = model.updated_at
    heart.save!
  end
end

def upload_photo json
  post = Post.find(json["id"])
  return if post.photos.any?

  pp "Post: #{post.id}"
  build_photo post, json["image"]

  json["comments"].each do |comment_json|
    comment = Comment.find(comment_json["id"])
    next if comment.photos.any?

    pp "Comment: #{comment.id}"
    build_photo comment, comment_json["image"]
  end
end

def build_photo model, src
  return unless src
  pp "attachemnt...#{Pathname.new(src).basename}"

  unless %{.jpg .jpeg .gif .png}.include? File.extname(src).downcase
    pp "Unsupported file type...skipping..................................................."
    return
  end

  photo = model.photos.build
  photo.image = File.new(src)
  photo.created_at = model.created_at
  photo.updated_at = model.updated_at
  pp "Uploading........"
  photo.save!
end

class GNode
  attr_accessor :id, :user_id, :content, :posted_on, :image, :location, :likes

  def initialize(node)
    @id = node.id
    @user = node.user.id
    @content = node.message.strip
    @posted_on = node.posted_on
    @image = image(node) if node.has_attachment?
    @location = node.location if node.has_location?
    @likes = node.likes if node.likes.any?
  end

  def image(node)
    File.join(Rails.root, "gb", "attachments", node.attachment)
  end

  def serialize
    # self.to_yaml
    self.to_json
  end
end

class GPost < GNode
  attr_accessor :comments

  def initialize(node)
    super(node)
    @comments = node.nodes.map {|c| GNode.new(c)}
  end
end

class Node
  @@sid = 1
  @@cid = 1

  attr_accessor :parent
  attr_reader :id, :user, :nodes, :post, :comment

  def initialize(div)
    @div = div
    @nodes = []
    @users = {}

    if is_status?
      @id = @@sid
      @@sid += 1
    else
      @id = @@cid
      @@cid += 1
    end
  end

  def exists?
    if is_status?
      Post.exists?(id: @id)
    else
      Comment.exists?(id: @id)
    end
  end

  def create_or_update
    if is_status?
      @post = user.posts.where(id: @id).first_or_create(post_params)
      spead_the_love @post
      upload_attachment @post
      @post
    else
      @comment = parent.post.comments.where(id: @id).first_or_create(comment_params)
      spead_the_love @comment
      upload_attachment @comment
      @comment
    end
  end

  def user_id(name)
    return @users[name] if @users[name].present?

    fname = name.split(" ").first
    user = User.find_by(first_name: fname)
    @users[name] = user.id
    @users[name]
  end

  def spead_the_love model
    likes.each do |user_name|
      user = User.find_by(first_name: user_name.split(" ").first)
      heart = model.hearts.build
      heart.user = user
      heart.created_at = model.created_at
      heart.updated_at = model.updated_at
      heart.save!
    end
    pp "<3...#{likes.join(', ')}"
  end

  def upload_attachment model
    return unless has_attachment?

    src = File.join(Rails.root, "gb", "attachments", attachment)

    pp "attachemnt...#{Pathname.new(src).basename}"
    unless %{.jpg .jpeg .gif .png}.include? File.extname(src)
      pp "Skipping..................................................." if %{.jpg .jpeg .gif .png}.include? File.extname(src)
      return
    end

    src_file = File.new(src)
    photo = model.photos.build
    photo.image = src_file
    photo.created_at = model.created_at
    photo.updated_at = model.updated_at
    pp "Uploading........"
    photo.save!
  end

  def image
    File.join(Rails.root, "gb", "attachments", attachment)
  end

  def photo_attributes
    [ image: image ]
  end

  def post_params
    {
        content: message,
        created_at: posted_on,
        updated_at: posted_on
    }
  end

  def comment_params
    {
      user: user,
      content: message,
      created_at: posted_on,
      updated_at: posted_on
    }
  end

  def to_json
    out = {
        id: id,
        content: message,
        posted_on: posted_on,
        user_id: user.id,
    }

    if message.length == 0
      out[:content] = ":)"
    end

    if has_attachment?
      out[:photo] = attachment
    end

    if has_location?
      out[:location] = location
    end

    if is_status?
      out[:comments] = nodes.map {|c| c.to_json}
    end

    out
  end

  def to_s
    type = is_status? ? "== S" : "---- C"
    "#{type}[#{self.id}] - #{self.user.first_name} - #{self.message}"
  end

  def user
    @user ||= User.find_by(first_name: author_first_name)
  end

  def add_node(node)
    node.parent = self
    @nodes << node
  end

  def is_status?
    @is_status ||= @div["class"] == "statusDiv"
  end

  def is_comment?
    @is_comment ||= @div["class"] == "commentDiv"
  end

  def author_name
    @author_name ||= if is_status?
      css("img.statusAuthorImg")["alt"]
    elsif is_comment?
      css("img.commentAuthorImg")["alt"]
    end
  end

  def author_first_name
    author_name.split(" ").first
  end

  def author_last_name
    author_name.split(" ").last
  end

  def author_image
    @author_image ||= if is_status?
      css("img.statusAuthorImg")["src"]
    elsif is_comment?
      css("img.commentAuthorImg")["src"]
    end
  end

  def message
    @message ||= begin
      msg = css("div.message").text
      msg = ":)" if msg.length == 0
      msg
    end
  end

  def posted_on
    @posted_on ||= DateTime.parse(css("span.pubDay").text)
  end

  def has_location?
    @has_location ||= @div.css("div.location").any?
  end

  def location_link
    @location_link ||= css("div.location a")["href"]
  end

  def location_text
    @location_text ||= css("div.location a").text
  end

  def has_attachment?
    @has_attachemnt ||= @div.css("div.attachment").any?
  end

  def attachment
    @attachment ||= css("img.attachmentImg")["src"][14..-1].strip
  end

  def likes
    @likes ||= @div.css("img.likeImg").map { |img| user_id(img["alt"]) }
    @likes ||= @div.css("img.likeimg").map { |img| user_id(img["alt"]) }
  end

  def location
    @location ||= location_link.split("q=").last.split(" ").first
  end

  def lat
    @lat ||= location.split(",").first
  end

  def long
    @long ||= location.split(",").last
  end

  private

    def css(selector)
      @div.css(selector)[0]
    end
end


