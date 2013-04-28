module CoreExt
  module MatchData
    module ToHash
      def to_hash
        self.names.each_with_object({}) do |name, result|
          result[name] = self[name]
        end
      end
    end
  end
end

MatchData.send :include, CoreExt::MatchData::ToHash