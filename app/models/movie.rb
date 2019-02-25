class Movie < ActiveRecord::Base
    def self.all_ratings
        return select("DISTINCT rating").map(&:rating).sort
    end
end
