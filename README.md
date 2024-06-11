# サービス名：あそびばさがそ
<img src="https://i.gyazo.com/3076c4c3920b82d24c822e334d7424f6.png" alt="Image from Gyazo" width="537"/>

## **サービスのURL**
ログインしなくてもメインの機能は使用できます  
https://where-do-you-take-your-kids.onrender.com  

## **サービス概要**  
・子供を遊びに連れて行く場所を検索できるサービス  
・ChatGPTを利用して選択項目から場所を検索し、該当する場所を提案する  
・場所の提案で決めた行き先の交通手段（車、公共交通機関）を提示する  

## **このサービスへの思い・作りたい理由**  
・休日に子供を遊ばせる場所が限られており、マンネリ化してしまっている  
・遊べる場所を調べてから交通手段を調べる手間を省くため、一つのアプリで完結できるものを作りたいと考え作成しました  

## **ユーザー層について**  
・子供を持つ家庭の親  

## **機能紹介** 
| トップ画面 | 検索結果画面 |
|:-:|:-:|
|![トップ画面](https://i.gyazo.com/d9ed534f344867e453d2fe903caaeb98.gif)|![検索結果一覧画面](https://i.gyazo.com/92af537863ae7bfb59d1923558b258a1.gif)|
| ページを開いてすぐアプリを使用できるようにしました。選択肢を少なくし簡単に検索できるようにしています。自動で住所を取得し、選択肢から選択された内容をもとにOPEN AI APIで場所の検索をします。 | Google places APIを使用し詳細情報を表示しています。ここにいくを押すとGoogle mapへ自動でルート案内ページに遷移します。 |  

## **ログインすると** 
| アカウント作成、ログイン | お気に入りの場所 |
|:-:|:-:|
|![アカウント作成、ログイン](https://i.gyazo.com/7462da0a6061cb6c3ed0025ee9912d13.gif)|![お気に入りの場所](https://i.gyazo.com/e2b45460a086f01c787d0e8cc3b920ce.gif)|
| 簡単にログインできるようにGoogleとLineでのログイン機能を実装しました。 | 検索結果からお気に入りを登録できお気に入り一覧ページからGoogle mapへ画面遷移できるようになります。 |  

 過去の検索結果一覧 | 行った場所の履歴 |
|:-:|:-:|
|![過去の検索結果一覧](https://i.gyazo.com/fa6182feddff768e0b3cea6dccdf2ab7.jpg) |![行った場所の履歴](https://i.gyazo.com/e589e8c62b9260d7d11430ef722ddbf5.jpg)|
| 過去に提示された検索結果を全て表示します。多くなってもすぐ見つけられるように一覧ページ全てで検索機能を実装しました。 | 行った場所の履歴を確認でき、行った場所のレビューを作成できます。 |  

 レビューの投稿 | レビューの一覧 |
 |:-:|:-:|
 |![レビューの投稿](https://i.gyazo.com/320185142d917586858215aec7116d79.gif) |![レビューの一覧](https://i.gyazo.com/539aa4e7634a8293c9c89a26438ab6e3.gif)|
| 行った場所に対しレビューが書けます。簡単に書けるように星ボタンを押すのとレビューを書くだけにしました。 | 投稿されたレビューを見ることができ、お気に入り、いいね、コメントもできます。 |  

 お気に入りのレビューと自身の投稿したレビューの一覧 | 通知機能 |
 |:-:|:-:|
 |![お気に入りのレビューと自身の投稿したレビューの一覧](https://i.gyazo.com/b0eeea8d2c1ea0a752ed817773fd674a.gif) |![通知機能](https://i.gyazo.com/86e116e29280b6247c02dbb98da7479b.gif)|
| お気に入りのレビューと自身の投稿したレビューの一覧を見ることができ検索もできます。 | 自身のレビューにいいね、コメントが貰えたら通知が来ます。 |  


## **このサービスを利用することで得られること**  
・子供を遊ばせる場所を調べ、交通手段を調べる手間を減らせます  
・4つの回答で遊び場が提示されるため、手間がかかりません  
・マンネリ化した遊び場を防ぎます  
・新しい体験を子供に提供します  
・掲示板を通じて良い点や悪い点を共有できます  

## **ユーザーの獲得について**  
・定期的にリリース情報を発信し、自分の家族や周囲の友人に使ってもらいます  

## **サービスの差別化ポイント・推しポイント**  
・遊ぶ場所を提示するサービスは多いですが、交通手段も提示するサービスが検索しても見つからなかった  
・簡単に遊び場を見つけることができます  

## **実装機能**  
・Geolocation API、Geocoding APIを使用して位置情報（住所）を取得  
・GPT-4o APIを使用して選択ボタンからの検索結果を表示  
・Directions API、NAVITIME Route(totalnavi)APIを使用しユーザーが選択した時間内に行ける場所のみ表示する   
・Places APIを用いて名前、住所、営業時間、公式HPの表示且つDirections API、NAVITIME Route(totalnavi)APIから取得した所要時間の表示  
・検索結果からGoogle Mapsに画面遷移し、ナビゲーションまたは乗換案内ページを表示する  
・1日辺りの検索回数の制限  
・新規ユーザーの登録  
・ログイン、ログアウト機能  
・Google Line ログイン  
・マイページ作成  
・行った場所の履歴の閲覧ページ  
・過去に検索した場所の一覧ページ  
・検索結果からお気に入り機能と一覧ページ  
・レビューの作成(投稿、いいね、コメント、検索、通知)  
・レビュー一覧ページ  
・お気に入りのレビュー一覧ページ  
・自身の投稿したレビュー一覧ページ  

## **技術スタック**

| カテゴリ       | 技術スタック|
| ------------ | ------------ |
| フロントエンド | HTML / CSS / JavaScript / Tailwind CSS |
| バックエンド   | Ruby 3.2.3 / Ruby on Rails 7.1.3.2 |
| データベース   | PostgreSQL |
| 認証           | Devise, Omniauth |
| API            | Google Geolocation API / Google Geocoding API / Google Maps JavaScript API / Google Places API / Google Directions API / GPT-4o API / NAVITIME Route(totalnavi) API |
| 環境構築       | Docker |
| CI/CD          | GitHub |
| インフラ       | Render / Amazon S3 |
| その他         | CarrierWave / Letter Opener Web |  


■画面遷移図  
https://www.figma.com/file/Zmwg6NA9cS3dE9wXsNsOQw/%E7%84%A1%E9%A1%8C?type=design&node-id=0-1&mode=design&t=vJeFECaBN8PdZ2rY-0  

■ER図
https://www.mermaidchart.com/app/projects/4feb60d4-9808-43f5-8ac2-939bd5fd67f8/diagrams/77c940ac-9313-49a4-a606-6b14ac6496cf/version/v0.1/edit