RSpec.describe User, type: :model do
  it_behaves_like 'PublicActivity::Owner', factory: :user

  it 'has a valid factory' do
    expect(FactoryBot.create(:user)).to be_valid
  end

  describe 'database' do
    it { is_expected.to have_db_index(:confirmation_token).unique }
    it { is_expected.to have_db_index(:email).unique }
    it { is_expected.to have_db_index(:reset_password_token).unique }
    it { is_expected.to have_db_index(:unlock_token).unique }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:role) }
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_length_of(:description).is_at_most(300) }
  end

  describe 'fields' do
    let(:user) { User.new }

    it '#flag_stamps is set by default, has getter and setter' do
      expect(user.flag_stamps).to be false
      user.flag_stamps = true
      expect(user.flag_stamps).to be true
    end
  end

  describe '#voting_power' do
    subject { user.voting_power }
    let(:user) { FactoryBot.create(:user, reputation: reputation) }

    context 'user has negative REP' do
      let(:reputation) { -100 }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'user has 0 REP' do
      let(:reputation) { 0 }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'user has positive REP' do
      context 'user has between 1..9 REP' do
        let(:reputation) { Faker::Number.between(1, 9) }

        it 'returns 1' do
          expect(subject).to eq(1)
        end
      end

      context 'user has between 10..99 REP' do
        let(:reputation) { Faker::Number.between(10, 99) }

        it 'returns 2' do
          expect(subject).to eq(2)
        end
      end

      context 'user has between 100..999 REP' do
        let(:reputation) { Faker::Number.between(100, 999) }

        it 'returns 3' do
          expect(subject).to eq(3)
        end
      end

      context 'user has between 1000..9999 REP' do
        let(:reputation) { Faker::Number.between(1000, 9999) }

        it 'returns 4' do
          expect(subject).to eq(4)
        end
      end
    end
  end

  describe '#can_vote?(votable)' do
    subject { user.can_vote?(votable) }

    let(:user) { FactoryBot.create(:user) }
    let(:votable) { FactoryBot.create(:label_stamp) }

    before do
      allow_required_integer_env('STAMP_CONCLUDE_IN_HOURS').and_return(72)
      allow_required_integer_env('USER_DAILY_VOTING_LIMIT').and_return(3)
    end

    context 'user already voted on votable' do
      before { FactoryBot.create(:vote, user: user, votable: votable) }

      it 'returns false' do
        expect(subject).to be false
      end
    end

    context 'user reached daily vote limit' do
      before { FactoryBot.create_list(:vote, 3, user: user) }

      it 'returns false' do
        expect(subject).to be false
      end
    end

    it 'returns true' do
      expect(subject).to be true
    end
  end
end
