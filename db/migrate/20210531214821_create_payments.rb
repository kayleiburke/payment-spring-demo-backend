class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.belongs_to :user
      t.float :amount
      t.string :description

      t.timestamps
    end
  end
end
