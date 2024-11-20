class AddUserToChallenges < ActiveRecord::Migration[7.0]
  def change
    # Step 1: Add the column without the `null: false` constraint
    add_reference :challenges, :user, foreign_key: true

    # Step 2: Set a default value for existing records
    Challenge.reset_column_information
    default_user = User.first || User.create!(email: 'default@example.com', password: 'password123') # Adjust this as needed
    Challenge.where(user_id: nil).update_all(user_id: default_user.id)

    # Step 3: Add the `null: false` constraint
    change_column_null :challenges, :user_id, false
  end
end
