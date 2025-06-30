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
    keywords: "絵文字, クイズ, Emoji Link",
    og: {
      site_name: :site,
      title: :title,
      description: :description,
      type: "website",
      url: request.original_url	,
      image: image_url('emojilink.jpg'),
      locale: "ja-JP"
    },
    twitter: {
      card: "summary_large_image",
      image: image_url('emojilink.jpg')
    }
  }
  end
end
