require 'spec_helper'

describe Bitcoin::Store::DB::LevelDB do

  let (:chain) { create_test_chain }
  subject { chain.db }
  after { chain.db.close }

  describe '#get_hash_from_height' do
    let(:payloads) do
      [
        "0100000043497fd7f826957108f4a30fd9cec3aeba79972084e90ead01ea330900000000bac8b0fa927c0ac8234287e33c5f74d38d354820e24756ad709d7038fc5f31f020e7494dffff001d03e4b672",
        "0100000006128e87be8b1b4dea47a7247d5528d2702c96826c7a648497e773b800000000e241352e3bec0a95a6217e10c3abb54adfa05abb12c126695595580fb92e222032e7494dffff001d00d23534",
        "0100000020782a005255b657696ea057d5b98f34defcf75196f64f6eeac8026c0000000041ba5afc532aae03151b8aa87b65e1594f97504a768e010c98c0add79216247186e7494dffff001d058dc2b6",
        "0100000010befdc16d281e40ecec65b7c9976ddc8fd9bc9752da5827276e898b000000004c976d5776dda2da30d96ee810cd97d23ba852414990d64c4c720f977e651f2daae7494dffff001d02a97640",
        "01000000dde5b648f594fdd2ec1c4083762dd13b197bb1381e74b1fff90a5d8b00000000b3c6c6c1118c3b6abaa17c5aa74ee279089ad34dc3cec3640522737541cb016818e8494dffff001d02da84c0",
        "01000000a1213bd4754a6606444b97b5e8c46e9b7832773ff434bd5f87ac45bc00000000d1e7026986a9cd247b5b85a3f30ecbabb6d61840d0abb81f905c411d5fc145e831e8494dffff001d004138f9",
        "010000007b0a09f26fdde2c432167d8349681c7801d0128f4dfae4dc5e68336600000000c1d71f59ce4419c793eb829380a41dc1ad48c19fcb0083b8f67094d5cae263ad81e8494dffff001d004ddad5",
        "01000000a62bc0c08afc1d12e6c6a7eb4a464c848190ac0e44123d5fa63a9ee2000000000214335cde9edeb6aa0195f68c08e5e46b07043e24aeff51fd9a3ff992ce6976a0e8494dffff001d02f33927",
        "01000000f9e2142a93185496f7b21314d8b6fa736d0a30fa3a6d339ab3a1ba9c0000000061974472615d348df6de106dbaaa08cf4dec65e39cefc62af6097b967b9bea52fde8494dffff001d00ca48a2",
        "010000001e93aa99c8ff9749037d74a2207f299502fa81d56a4ea2ad5330ff50000000002ec2266c3249ce2e079059e0aec01a2d8d8306a468ad3f18f06051f2c3b1645435e9494dffff001d008918cf",
        "010000002e9afd58b91f15c3ec9eb0f01ed9d503134da1918b6bb416a9920e700000000029fb495afdb58f3a26d1c90fafec93aed840e2fa37ad6173ba1e7fadb7121ee57de9494dffff001d02e7f318",
        "0100000027e0ca29a9802c0a2390ecfa90a9bd814fecc54446510e155652dead000000007e8d5344557575c8f018cc62a32e8e0bd80638643b4ec34945ec4662fcab138142ea494dffff001d04acbc3c",
        "01000000001f3ada9b561378e324e80ee68facd5d232f72f773b86328393054700000000eaf3be35e3f0ace8b6abdeb5509d72999eae2329657238b53fa437e319c8e96b99ea494dffff001d027801a8",
        "01000000781bc7847e15c3b936a6a6a178e38fa29ee6e4916a8a62e10795c69200000000d44c3443fa8bd88bf32b94b9257f09ce6fb6ec0d5420504d631568f8685200dfa1ea494dffff001d01f781d0",
        "01000000133991a938b505ee8f6f347f313c3372d82a9d8b42b08b0dd0fc086400000000a0ef58c239e0197a65aa248c2cf52c437d8c8ea30d1b835e630a87c941f7d4e9adea494dffff001d030ef2e0",
        "0100000028d34cdb13e555032e4bec55fcce3d0fef8212803fb1bab851e1259400000000542c71544b9f28bd5a6fec95ecd509ae49d0b04f8718c685d0751f71d38285d0c3ea494dffff001d056b3115"
      ]
    end

    before do
      payloads.each_with_index do |payload, i|
        header = Bitcoin::BlockHeader.parse_from_payload(payload.htb)
        subject.save_entry(Bitcoin::Store::ChainEntry.new(header, i + 1))
      end
    end

    it do
      # see: https://github.com/haw-itn/bitcoinrb/issues/8
      expect(subject.get_hash_from_height(1)).to eq '06128e87be8b1b4dea47a7247d5528d2702c96826c7a648497e773b800000000'
      expect(subject.get_hash_from_height(16)).to eq '6b00cf1ce31b33fe1e2c4648a0834dedd972ffb2a2f341f75ad7cbc400000000'
    end
  end
end