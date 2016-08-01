require "anyflake/version"

# Pure ruby independent ID generator like the Snowflake, ChiliFlake.
# @see https://github.com/twitter/snowflake
# @see https://github.com/ma2shita/chiliflake
class AnyFlake
  TIMESTAMP_BITS = 41
  NODE_ID_BITS   = 10
  SEQUENCE_BITS  = 12

  MAX_NODE_ID  = (1 << NODE_ID_BITS) # 1024
  MAX_SEQUENCE = (1 << SEQUENCE_BITS) # 4096

  @target_epoch = nil
  @node_id      = nil
  @sequence     = nil
  @last_time    = nil

  def initialize(target_epoch, node_id, sequence = 0)
    raise OverflowError, "invalid node_id (#{node_id} >= #{MAX_NODE_ID})" if node_id >= MAX_NODE_ID
    raise OverflowError, "invalid sequence (#{sequence} >= #{MAX_SEQUENCE})" if sequence >= MAX_SEQUENCE
    @target_epoch = target_epoch
    @node_id      = node_id % MAX_NODE_ID
    @sequence     = sequence % MAX_SEQUENCE
    @last_time    = current_time
  end

  def next_id
    time = current_time

    raise InvalidSystemClockError, "(#{time} < #{@last_time})" if time < @last_time

    if time == @last_time
      @sequence = (@sequence + 1) % MAX_SEQUENCE
      # NOTE: Distributed in node_id so if more than MAX_SEQUENCE, or wait until the next time.
      # time = till_next_time if @sequence == 0
    else
      @sequence = 0
    end

    @last_time = time

    compose(@last_time, @node_id, @sequence)
  end

  def parse(flake_id)
    AnyFlake.parse(flake_id, @target_epoch)
  end

  def self.parse(flake_id, target_epoch)
    hash = {}
    hash[:epoch_time] = flake_id >> (SEQUENCE_BITS + NODE_ID_BITS)
    hash[:time]       = Time.at((hash[:epoch_time] + target_epoch) / 1000.0)
    hash[:node_id]    = (flake_id >> SEQUENCE_BITS).to_s(2)[-NODE_ID_BITS, NODE_ID_BITS].to_i(2)
    hash[:sequence]   = flake_id.to_s(2)[-SEQUENCE_BITS, SEQUENCE_BITS].to_i(2)
    hash
  end

  private

  def compose(last_time, node_id, sequence)
    ((last_time - @target_epoch) << (SEQUENCE_BITS + NODE_ID_BITS)) +
      (node_id << SEQUENCE_BITS) +
      sequence
  end

  def current_time
    Time.now.strftime('%s%L').to_i
  end
end

class AnyFlake::OverflowError < StandardError; end
class AnyFlake::InvalidSystemClockError < StandardError; end
