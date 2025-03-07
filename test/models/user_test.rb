# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                          :integer          not null, primary key
#  administrator               :boolean          default(FALSE)
#  agreed                      :boolean
#  agreed_time                 :datetime
#  company                     :string(255)
#  completed_case_wizard       :boolean          default(FALSE), not null
#  email                       :string(80)
#  email_marketing             :boolean          default(FALSE), not null
#  invitation_accepted_at      :datetime
#  invitation_created_at       :datetime
#  invitation_limit            :integer
#  invitation_sent_at          :datetime
#  invitation_token            :string(255)
#  invitations_count           :integer          default(0)
#  locked                      :boolean
#  locked_at                   :datetime
#  name                        :string(255)
#  num_logins                  :integer
#  password                    :string(120)
#  profile_pic                 :string(255)
#  reset_password_sent_at      :datetime
#  reset_password_token        :string(255)
#  stored_raw_invitation_token :string(255)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  default_scorer_id           :integer
#  invited_by_id               :integer
#
# Indexes
#
#  index_users_on_default_scorer_id     (default_scorer_id)
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_name                  (name)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  ix_user_username                     (email) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (default_scorer_id => scorers.id)
#

require 'test_helper'
# rubocop:disable Layout/LineLength
class UserTest < ActiveSupport::TestCase
  test 'membership in team' do
    assert_includes users(:doug).teams, teams(:shared)
  end

  test 'ownership of team' do
    assert_includes users(:doug).owned_teams, teams(:valid)
  end

  describe 'Defaults' do
    test 'are set when user is created' do
      user = User.create(email: 'defaults@email.com', password: 'password')

      assert_not_nil user.completed_case_wizard
      assert_not_nil user.num_logins

      assert_equal false, user.completed_case_wizard
      assert_equal 0,                        user.num_logins
      assert_equal user.default_scorer.name, Rails.application.config.quepid_default_scorer
    end

    test 'do not override the passed in arguments' do
      user = User.create(
        email:                 'defaults@email.com',
        password:              'password',
        completed_case_wizard: true,
        num_logins:            1
      )

      assert_not_nil user.completed_case_wizard
      assert_not_nil user.num_logins

      assert_equal true, user.completed_case_wizard
      assert_equal 1, user.num_logins
    end
  end

  describe 'Password' do
    let(:user) { users(:doug) }

    test 'encrypts password when creating a new password' do
      password = 'password'
      new_user = User.create(email: 'new@user.com', password: password)

      assert_not_equal password, new_user.password
      assert BCrypt::Password.new(new_user.password) == password
    end

    test 'does not encrypt the password when updating a user without the password' do
      current_password = user.password
      user.update num_logins: 3

      assert_equal current_password, user.password
    end

    test "encrypts password when updating a user's password" do
      current_password  = user.password
      password          = 'newpass'
      user.update num_logins: 3, password: password

      assert_not_equal  current_password, user.password

      assert_not_equal  password, user.password
      assert BCrypt::Password.new(user.password) == password
    end
  end

  describe 'Agreed' do
    test 'Does not set agreed_time when agreed is nil or false' do
      password = 'password'
      new_user = User.create(email: 'new@user.com', password: password, agreed: nil)
      assert_nil new_user.agreed_time

      new_user = User.create(email: 'new@user.com', password: password, agreed: false)
      assert_nil new_user.agreed_time
    end

    test 'Sets agreed_time when agreed set to true when T&C set' do
      user = User.create
      assert user.terms_and_conditions?

      password = 'password'
      new_user = User.create(email: 'new@user.com', password: password, agreed: true)
      assert_not_nil new_user.agreed_time
    end

    test 'Sets agreed_time when agreed set to true when T&C not set' do
      terms_and_conditions_url = Rails.application.config.terms_and_conditions_url
      Rails.application.config.terms_and_conditions_url = ''
      user = User.create
      assert_not user.terms_and_conditions?

      Rails.application.config.terms_and_conditions_url = nil
      user = User.create
      assert_not user.terms_and_conditions?

      password = 'password'
      new_user = User.create(email: 'new@user.com', password: password, agreed: true)
      assert_nil new_user.agreed_time
      Rails.application.config.terms_and_conditions_url = terms_and_conditions_url
    end
  end

  describe 'Email' do
    test 'validates the format of the email address' do
      new_user = User.create(email: nil, password: 'password')

      assert new_user.errors.added? :email, :blank # => true
      assert_includes new_user.errors.messages[:email], 'can\'t be blank'

      new_user = User.create(email: 'epugh', password: 'password')
      assert_includes new_user.errors.messages[:email], 'is invalid'

      new_user = User.create(email: 'epugh@', password: 'password')
      assert_includes new_user.errors.messages[:email], 'is invalid'

      # turns out this is a valid format at least as far as regex validation goes!
      new_user = User.create(email: 'epugh@o19s', password: 'password')
      assert_empty new_user.errors.messages

      new_user = User.create(email: 'epugh@o19s.com', password: 'password')
      assert_empty new_user.errors.messages
      new_user = User.create(email: 'epugh+tag@o19s.com', password: 'password')
      assert_empty new_user.errors.messages
    end
  end

  describe 'Default Case' do
    # we used to create the default case for every user, but that assumptions doesn't make sense anymore.
    test 'when user is created a default case is NOT automatically created' do
      case_count = Case.count
      user = User.create email: 'foo@example.com', password: 'foobar'

      assert_not_nil  user.cases
      assert_equal    user.cases.count, 0
      assert_same     case_count, Case.count
    end
  end

  describe 'Lock User' do
    let(:user) { users(:random) }

    it 'defaults the user to unlocked' do
      assert_not user.locked?
    end

    it 'switches the user to locked' do
      user.lock
      user.save

      assert user.locked?
    end

    it 'unlocks a user' do
      user.lock
      user.save

      assert user.locked?

      user.reload
      user.unlock
      user.save

      assert_not user.locked?
    end
  end

  describe 'Delete User' do
    let(:user)          { users(:team_owner) }
    let(:team_member_1) { users(:team_member_1) }
    let(:shared_team_case) { cases(:shared_team_case) }
    let(:team) { teams(:valid) }

    let(:random) { users(:random) }

    let(:team_owner) { users(:team_owner) }
    let(:team_member_1) { users(:team_member_1) }
    let(:shared_team_case) { cases(:shared_team_case) }

    it 'prevents a user who owns a team that other people are in from being deleted' do
      user.destroy
      assert_not user.destroyed?

      assert user.errors.full_messages_for(:base).include?('Please reassign ownership of the team Team owned by Team Owner User.')
    end

    it 'prevents a user who owns a scorer shared with a team from being deleted' do
      random.destroy
      assert_not random.destroyed?
      assert random.errors.full_messages_for(:base).include?('Please remove the scorer Scorer for sharing from the team before deleting this user.')
    end

    it 'deletes a user and their team if no one else is in the team' do
      team = team_owner.teams.first
      team.owner = team_member_1
      team.save

      assert_not shared_team_case.destroyed?

      assert_difference('User.count', -1) do
        team_owner.destroy
        assert team_owner.destroyed?
      end

      shared_team_case.reload
      assert_not shared_team_case.destroyed?
    end
  end

  describe 'User accessing Books' do
    let(:user_with_book_access)             { users(:doug) }
    let(:user_without_book_access)          { users(:joey) }
    let(:book_of_comedy_films)              { books(:book_of_comedy_films) }
    let(:book_of_star_wars_judgements)      { books(:book_of_star_wars_judgements) }

    it 'provides access to the books that a user has access because of membership in a team' do
      assert_equal user_with_book_access.books_involved_with.where(id: book_of_star_wars_judgements.id).first, book_of_star_wars_judgements
    end

    it 'prevents access to the books because the user is not part of a team' do
      assert_nil user_without_book_access.books_involved_with.where(id: book_of_comedy_films).first
    end
  end
end

# rubocop:enable Layout/LineLength
