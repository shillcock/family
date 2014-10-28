class SmsPost
  attr_reader :post

  def initialize(user, params)
    @user = user
    @params = params
    @post = build_comment
    @post ||= build_post
    build_photos if @post
  end

  def save
    @post.save
  end

  def send_notifications!
    @post.send_notifications!
  end

  private
    def sms_body
      @body ||= @params["Body"]
    end

    def sms_media_count
      @params["NumMedia"].to_i
    end

    def sms_media_url(id)
      @params["MediaUrl#{id}"]
    end

    def sms_media_type(id)
      @params["MediaContentType#{id}"]
    end

    def sms_media_is_image?(id)
      sms_media_type(id).starts_with? "image"
    end

    def post_id
      regex = Regexp.new(/\A#?(\d+[\s])(.+)/m)
      match = regex.match(sms_body)
      if match
        @body = match[2]
        match[1]
      end
    end

    def build_post
      @user.posts.build(content: sms_body)
    end

    def build_comment
      post = Post.find_by(id: post_id)
      post.comments.build(content: sms_body, user: @user) if post
    end

    def build_photos
      parent = @post || @comment
      sms_media_count.times do |ix|
        if sms_media_is_image?(ix)
          photo = parent.photos.build
          photo.remote_image_url = sms_media_url(ix)
          photo.user = parent.user
        end
      end
    end
end

