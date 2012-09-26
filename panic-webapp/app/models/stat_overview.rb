class StatOverview < ActiveRecord::Base
  serialize :strength_points
  serialize :length_points
  serialize :complexity_points

  serialize :length_distribution
  serialize :strength_distribution
  serialize :complexity_distribution

  serialize :most_common_passwords

  def calc_top_passwords
    raw_sql = "SELECT COUNT(password), password FROM credentials WHERE password is not null GROUP BY password"
    self.most_common_passwords = ActiveRecord::Base.connection.select_all raw_sql
  end

  def calc_distributions
    raw_sql = "SELECT password FROM credentials WHERE password is not null"
    pws = ActiveRecord::Base.connection.select_all raw_sql

    self.length_distribution = pws.collect { |pw| pw.length }.summary
    self.complexity_distribution = pws.collect { |pw| pw.character_complexity }.summary
    self.strength_distribution = pws.collect { |pw| pw.strength }.summary
  end

  def calc_scatterplots
    # TODO
  end

  def calc_all
    calc_top_passwords
    calc_distributions
    calc_scatterplots
  end
end
