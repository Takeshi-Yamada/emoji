module ApplicationHelper
  def flash_background_color(type)
    case type.to_sym
    when :notice then "bg-green-500"
    when :alert  then "bg-red-500"
    when :error  then "bg-yellow-500"
    else "bg-gray-500"
    end
  end

  def default_meta_tags
  {
    site: "🧩Emoji Link",
    title: "🧩Emoji Link",
    reverse: true,
    charset: "utf-8",
    description: "Emoji Linkは、絵文字だけで出題されたクイズに挑戦できるWebアプリです。あなたの推し作品、絵文字で伝わる？クイズ投稿機能もあり！",
    keywords: "Emoji, 絵文字, クイズ, Emoji Link",
    og: {
      site_name: :site,
      title: :title,
      description: :description,
      type: "website",
      url: request.original_url,
      image: ogp_image_url,
      locale: "ja-JP"
    },
    twitter: {
      card: "summary_large_image",
      image: ogp_image_url
    }
  }
  end

  def ogp_image_url
    if @question&.id
      public_id = "ogp_images/question_#{@question.id}"
      cloud_name = ENV["CLOUDINARY_CLOUD_NAME"]
      return "https://res.cloudinary.com/#{cloud_name}/image/upload/#{public_id}.png"
    end
    # デフォルトOGP画像
    image_url("emojilink.jpg")
  end
end
