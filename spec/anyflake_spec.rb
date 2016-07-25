require 'spec_helper'

describe Anyflake do
  it 'has a version number' do
    expect(Anyflake::VERSION).not_to be nil
  end

  before do
    @target_epoch = Time.new(2016, 7, 1, 0, 0, 0).strftime('%s%L').to_i
    @current_time = Time.new(2016, 7, 25, 0, 0, 0).strftime('%s%L').to_i
    allow_any_instance_of(AnyFlake).to receive(:current_time).and_return(@current_time)
  end

  context 'normals' do
    it '#next_id' do
      node_id = 1
      sequence = 0
      anyflake = AnyFlake.new(@target_epoch, node_id, sequence)
      flake_id = anyflake.next_id
      sequence += 1 # for incremented in next_id function
      parsed = anyflake.parse(flake_id)
      expect(parsed[:epoch_time]).to eq @current_time - @target_epoch
      expect(parsed[:time]).to eq Time.at(@current_time / 1000.0)
      expect(parsed[:node_id]).to eq node_id
      expect(parsed[:sequence]).to eq sequence
    end

    it '#parse' do
      anyflake = AnyFlake.new(@target_epoch, 0, 0)
      parsed = anyflake.parse(8697308774404097)
      expect(parsed[:epoch_time]).to eq @current_time - @target_epoch
      expect(parsed[:time]).to eq Time.at(@current_time / 1000.0)
      expect(parsed[:node_id]).to eq 1
      expect(parsed[:sequence]).to eq 1
    end
  end

  context 'errors' do
    it 'overflow node_id' do
      expect { AnyFlake.new(@target_epoch, 1024, 0) }.to raise_error AnyFlake::OverflowError
    end

    it 'overflow sequence' do
      expect { AnyFlake.new(@target_epoch, 0, 4096) }.to raise_error AnyFlake::OverflowError
    end

    it 'invalid system clock' do
      anyflake = AnyFlake.new(@target_epoch, 0, 0)
      anyflake.instance_variable_set(:@last_time, (1 << AnyFlake::TIMESTAMP_BITS))
      expect { anyflake.next_id }.to raise_error AnyFlake::InvalidSystemClockError
    end
  end

  context 'class methods' do
    it '#self.parse' do
      parsed = AnyFlake.parse(8697308774404097, @target_epoch)
      expect(parsed[:epoch_time]).to eq @current_time - @target_epoch
      expect(parsed[:time]).to eq Time.at(@current_time / 1000.0)
      expect(parsed[:node_id]).to eq 1
      expect(parsed[:sequence]).to eq 1
    end
  end
end
