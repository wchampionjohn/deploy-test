class AddKabobAccessTokenToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :kabob_access_token, :string, comment: 'Kabob平台存取令牌'
  end
end
