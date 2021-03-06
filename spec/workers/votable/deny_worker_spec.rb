RSpec.describe Votable::DenyWorker, type: :worker do
  describe '#perform' do
    subject { deny_worker.perform(votable_type, votable_id) }
    let(:deny_worker) { Votable::DenyWorker.new }

    include_context 'with activity tracking'

    context 'votable exists' do
      let(:votable) { FactoryBot.create(:label_stamp, state: state) }
      let(:votable_type) { votable.class.to_s }
      let(:votable_id) { votable.id }

      context 'state is not :in_progress' do
        let(:state) { :denied }

        it 'raises Votable::NotInProgressError' do
          expect { subject }.to raise_error(Votable::NotInProgressError)
        end
      end

      context 'state is :in_progress' do
        let(:state) { 'in_progress' }

        it 'calls votable#deny!' do
          expect_any_instance_of(Stamp).to receive(:deny!)
          subject
        end

        it 'denies the votable' do
          expect { subject }.to change { votable.reload.state }.from(state).to('denied')
        end
      end
    end
  end
end
