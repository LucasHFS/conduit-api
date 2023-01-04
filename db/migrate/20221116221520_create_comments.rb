# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text :body
      t.references :user, null: false, index: true, foreign_key: true
      t.references :article, null: false, index: true, foreign_key: true

      t.timestamps
    end
  end
end
