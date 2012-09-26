class StatOverview < ActiveRecord::Base
  serialize :strength_points
  serialize :length_points
  serialize :complexity_points

  serialize :length_distribution
  serialize :strength_distribution
  serialize :complexity_distribution

  serialize :most_common_passwords

  def calc_top_passwords
    raw_sql = "SELECT COUNT(password) as pw_count, password FROM credentials WHERE password is not null GROUP BY password ORDER BY pw_count DESC LIMIT 20"
    self.most_common_passwords = ActiveRecord::Base.connection.select_all raw_sql
    self
  end

  def calc_distributions
    raw_sql = "SELECT password FROM credentials WHERE password is not null"
    pws = ActiveRecord::Base.connection.select_all(raw_sql)
    pws.collect! { |pw| pw["password"] }

    self.strength_distribution = pws.collect { |pw| pw.strength }.summary
    self.length_distribution = pws.collect { |pw| pw.length }.summary
    self.complexity_distribution = pws.collect { |pw| pw.character_complexity }.summary
    self
  end

  def calc_scatterplots
    leaks = Leak.where("leaked_on IS NOT NULL AND stats IS NOT NULL AND leaked_on < '2015-12-20'").order("leaked_on").select { |l| l.stats and l.stats[:length][:median] }
    self.strength_points = leaks.collect { |l| [ l.leaked_on.to_i * 1000, l.stats[:strength][:median] ] }
    self.length_points = leaks.collect { |l| [ l.leaked_on.to_i * 1000, l.stats[:length][:median] ] }
    self.complexity_points = leaks.collect { |l| [ l.leaked_on.to_i * 1000, l.stats[:character_complexity][:median] ] }
    self
  end

  def calc_all
    calc_top_passwords
    calc_distributions
    calc_scatterplots
    self
  end
end
