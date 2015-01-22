class SmsPost
  def initialize(user, params)
    @user = user
    @params = params
    @notify = true
    process_body
    build_post_or_comment
    build_photos
  end

  def save
    @sms_post.save
  end

  def send_notifications!
    @sms_post.send_notifications! if @notify
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

    def process_body
      regex = Regexp.new(/\A#?(\d+[\s])/)
      match = regex.match(sms_body)
      if match
        @post_id = match[1].strip.to_i
        @body = sms_body[match[1].length..-1]
      end
    end

    def build_post_or_comment
      @post = Post.find_by(id: @post_id)
      if @post
        build_comment
      else
        build_post
      end
    end

    def build_post
      @post = Post.last
      if (Time.zone.now - @post.updated_at) <= 10.seconds and @post.user == @user
        @sms_post = @post
        @sms_post.content = @post.content + sms_body
        @notify = false
        Rollbar.info("Appended sms txt to last post #{@post.id} from #{@user.first_name}.")
      else
        @sms_post = @user.posts.build(content: sms_body)
      end
    end

    def build_comment
      @sms_post = @post.comments.build(content: sms_body, user: @user)
    end

    def build_photos
      sms_media_count.times do |ix|
        if sms_media_is_image?(ix)
          photo = @sms_post.photos.build
          photo.remote_image_url = sms_media_url(ix)
          photo.user = @sms_post.user
        end
      end
    end
end

