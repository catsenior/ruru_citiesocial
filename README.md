# 復刻 Citiesocial
- 網址: http://35.229.146.105

  - 前台: http://35.229.146.105
  - 後台: http://35.229.146.105/admin (後台有權限驗證，非admin帳號無法進入)

  - 會員功能
  - 串接第三方登入:Google
  - 個人資料編輯
  - 訂單紀錄
  - 購物車
  - 付費串接Line Pay結帳
  - 商品列表
  - 商品分類
  - 訂閱電子報

- 後台

  - 商品新增修改刪除

  - 商品照片上傳
  - 商品分類
  - 新增商品品項
  - 文章編輯器
  - 商品可勾選是否上架
  - 分類列表
  - 新增修改刪除分類(可拖拉排序)
  - 廠商列表
  - 新增修改刪除廠商
  - 聖誕節滿千享九折優惠活動
- 測試帳號

  - 帳號: root@example.com (admin)
  - 密碼: 123456

  - 帳號: test123@example.com
  - 密碼: 123456

## 開發
- 版本：Rails(6.1.6)、Ruby(2.6.6)
- CSS  : Bulma 、Font awesome
- 資料庫 : PostgreSQL
- 前後端資料串接：Stimulus.js
- 原始碼管理: GitHub

## Tools
- Devise : 使用者認證 
- paranoia : 物件使用軟刪除
- Webpacker: 打包前端的 css, javascript
- figaro: 管理敏感資訊
- friendly_id : 亂數產生訂單編號、商品編號
- foreman: Procfile 套件
- yarn : package 管理器 
- Action Text : 文字編輯器 
- acts_as_list : 對列表進行排序和重新排序
- Sortable : 前端拖拉功能(js 套件)
- rspec-rails : 測試套件
- factory_bot_rails : 產生測試需要的假資料
- Faraday : HTTP Request
- timecop : 模擬系統時間
- AASM : 狀態機
