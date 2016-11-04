require 'spec_helper'
require 'ladon'

module Ladon
  module Automator
    module Timing
      RSpec.describe Timer do
        let(:timer_name) { 'some_name' }
        subject(:timer) { Timer.new }

        describe '#new' do
          it { is_expected.to have_attributes(entries: []) }
        end

        describe '#for' do
          context 'when given no block' do
            it 'raises an error' do
              expect { subject.for(timer_name) }.to raise_error(StandardError)
            end
          end

          context 'when given a block' do
            it 'records a new entry with a start time' do
              expect { subject.for(timer_name) {} }.to change { subject.entries.size }.by(1)
              expect(subject.entries.last.start_time).to be_a(Time)
            end

            context 'when the block is safe (one that will not raise)' do
              # We will use an empty block, which would appear to be inherently safe.
              it 'does not raise an error' do
                expect { subject.for(timer_name) {} }.not_to raise_error
              end

              it 'records a new entry with an end time' do
                subject.for(timer_name) {}
                new_entry = subject.entries.last
                expect(new_entry.end_time).to be_a(Time) # end time should be a time
                expect(new_entry.end_time).to be > new_entry.start_time # end time should be after start time
              end
            end

            context 'when given an unsafe block' do
              let(:error_type) { Class.new(StandardError) }
              it 'will raise the error from the block' do
                expect { subject.for(timer_name) { raise error_type } }.to raise_error(error_type)
              end
            end
          end
        end
      end
    end
  end
end
