module ApplicationHelper
  def default_meta_tags
  {
    site: "🍌Banana Fortune",
    title: "本日のウホ報！",
    reverse: true,
    charset: "utf-8",
    description: "バナナで今日の運勢を占おう！",
    keywords: "占い, ゴリラ, バナナ, Banana, Fortune, ウホ",
    og: {
      site_name: :site,
      title: :title,
      description: :description,
      type: 'website',
      url: root_url,
      image: image_url("banana_fortune.jpg"),
      locale: "ja-JP"
    },
    twitter: {
      card: "summary_large_image",
      image: image_url("banana_fortune.jpg")
    }
  }
  end
end
