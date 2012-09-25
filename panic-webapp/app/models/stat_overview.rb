class StatOverview < ActiveRecord::Base
  serialize :strength_points
  serialize :length_points
  serialize :complexity_points

  serialize :length_distribution
  serialize :strength_distribution
  serialize :complexity_distribution

  serialize :most_common_passwords

  def recalc_stats
    # Cache passwords so we don't rebuild this for each calculation
    pws = Credential.where("password IS NOT NULL").map { |p| p.password }

    pw_count = Hash.new
    pws.each { |p|
      pw_count[p] = 0 unless pw_count[p]
      pw_count[p] += 1
    }
    inverted_count = pw_count.invert
    inverted_count.keys.sort[0..10]
    # TODO: Finish this

    self.length_distribution = pws.collect { |pw| pw.length }.summary
    self.complexity_distribution = pws.collect { |pw| pw.character_complexity }.summary
    self.strength_distribution = pws.collect { |pw| pw.strength }.summary
  end
end
