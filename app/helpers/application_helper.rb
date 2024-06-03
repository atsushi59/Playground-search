# frozen_string_literal: true

module ApplicationHelper
  def flash_class(flash_type)
    case flash_type.to_sym
    when :notice then 'bg-green-400 text-white text-xl font-mono font-bold p-4'
    when :alert then 'bg-red-400 text-gray-100 text-xl font-mono font-bold p-4'
    else 'bg-blue-400 text-white text-xl font-mono font-bold p-4'
    end
  end

  def prefecture_options
    %w[
      北海道 青森県 岩手県 宮城県 秋田県 山形県 福島県
      茨城県 栃木県 群馬県 埼玉県 千葉県 東京都 神奈川県
      新潟県 富山県 石川県 福井県 山梨県 長野県 岐阜県
      静岡県 愛知県 三重県 滋賀県 京都府 大阪府 兵庫県
      奈良県 和歌山県 鳥取県 島根県 岡山県 広島県 山口県
      徳島県 香川県 愛媛県 高知県 福岡県 佐賀県 長崎県
      熊本県 大分県 宮崎県 鹿児島県 沖縄県
    ]
  end

  def unchecked_notifications
    current_user.notifications_as_visited.where(read: false)
  end

  def default_meta_tags
    {
      site: 'あそびばさがそ',
      title: 'AIを使用した検索、ルート案内サービス',
      reverse: true,
      charset: 'utf-8',
      description: 'あそびばさがそを使えば、子供の遊べる場所を簡単に検索し、ルート案内します',
      keywords: '検索,ルート,子供,生成AI',
      canonical: request.original_url,
      separator: '|',
      og: {
        site_name: 'あそびばさがそ',
        title: 'AIを使用した検索、ルート案内サービス',
        description: 'あそびばさがそを使えば、子供の遊べる場所を簡単に検索し、ルート案内します',
        type: 'website',
        url: request.original_url,
        image: image_url('ogp.png'),
        locale: 'ja_JP',
        separator: '|',
      },
      twitter: {
        card: 'summary_large_image',
        site: '@ツイッターのアカウント名',
        image: image_url('ogp.png'),
      }
    }
  end
end
