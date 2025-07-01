require 'openai'

class QuizSupport
  def self.call(answer)
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
    response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [
          {
            role: "system",
            content: <<~PROMPT
              ユーザーが入力したお題（例: 作品名）を元に、以下のフォーマットで出力してください。
              ・絵文字6個以内（重要なものほど左に）
              ・ヒントを3つ（それぞれ20文字程度）
              出力例：
              絵文字: 📓🖊️🍎👿
              ヒント1: ジャンプの漫画作品です。
              ヒント2: 名前を書くと◯ぬノートが登場します。
              ヒント3: 「新世界の神になる」と言い出す天才高校生が主人公です。
            PROMPT
          },
          { role: "user", content: answer }
        ]
      }
    )

    content = response.dig("choices", 0, "message", "content")

    # 結果の整形
    {
      emoji: content[/絵文字[:：]\s*(.+)/, 1]&.strip || "",
      hint_1: content[/ヒント1[:：]\s*(.+)/, 1]&.strip || "",
      hint_2: content[/ヒント2[:：]\s*(.+)/, 1]&.strip || "",
      hint_3: content[/ヒント3[:：]\s*(.+)/, 1]&.strip || ""
    }
  end
end