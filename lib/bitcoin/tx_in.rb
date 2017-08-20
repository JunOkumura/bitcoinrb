module Bitcoin

  # transaction input
  class TxIn

    attr_accessor :out_point
    attr_accessor :script_sig
    attr_accessor :sequence
    attr_accessor :script_witness

    DEFAULT_SEQUENCE = 0xFFFFFFFF

    def initialize(out_point: nil, script_sig: nil, script_witness: ScriptWitness.new, sequence: DEFAULT_SEQUENCE)
      @out_point = out_point
      @script_sig = script_sig
      @script_witness = script_witness
      @sequence = sequence
    end

    def self.parse_from_payload(payload)
      buf = payload.is_a?(String) ? StringIO.new(payload) : payload
      i = new
      hash, index = buf.read(36).unpack('a32V')
      i.out_point = OutPoint.new(hash.reverse.bth, index)
      sig_length = Bitcoin.unpack_var_int_from_io(buf)
      sig = buf.read(sig_length)
      i.script_sig = Script.new
      i.script_sig.chunks[0] = sig
      i.sequence = buf.read(4).unpack('V').first
      i
    end

    def coinbase?
      out_point.coinbase?
    end

    def to_payload(script_sig = @script_sig, sequence = @sequence)
      p = out_point.to_payload
      p << Bitcoin.pack_var_int(script_sig.to_payload.bytesize)
      p << script_sig.to_payload << [sequence].pack('V')
    end

  end

end
