class Timefly

  attr_accessor :origin_time

  def initialize(origin_time)
    self.origin_time = origin_time
    process
  end

  # returns the age in years from the date of birth
  #
  # Example:
  #   >> dob = Time.new(1987,8,2)
  #   >> TimeCapsule.age(dob)
  #   => 27
  #   >> TimeCapsule.age('1987.08.02') # dob can be of format YYYY.MM.DD, YYYY-MM-DD and YYYY/MM/DD
  #   => 27
  #   >> TimeCapsule.age('1987.08.02', { format: '%y years, %m months' })
  #   => 27 years, 10 months
  #
  # Arguments:
  #   dob: (Time/String)
  #   options: (Hash) { format  :(String) }
  #                             eg, '%y years, %m months'. %y will give years, and %m will give months
  def age(options = {})
    if options[:format].nil?
      years_from_origin_time
    else
      options[:format]
        .gsub(/\%y/, years_from_origin_time.to_s)
        .gsub(/\%m/, months_diff_from_origin_time_month.to_s)
    end
  end

  private

  # This method tries to convert the origin_time to Time
  def process
    if origin_time.is_a? String
      convert_string_origin_time
    elsif !origin_time.is_a?(Time) && !origin_time.is_a?(Date)
      fail("#{origin_time.class.name} is not a supported origin_time")
    end
  end

  #convert dob to Time if it is in String
  def convert_string_origin_time
    separator = '.'
    if origin_time.include?('/')
      separator = '/'
    elsif origin_time.include?('-')
      separator = '-'
    end
    dob_arr = origin_time.split(separator).map{ |d| d.to_i }
    self.origin_time = Time.new(dob_arr[0], dob_arr[1], dob_arr[2])
  end

  # This method gets the months difference since the origin_time month
  def months_diff_from_origin_time_month
    dob_month = dob.strftime('%m').to_i
    now_month = Time.now.strftime('%m').to_i
    if dob_month == now_month
      0
    elsif dob_month > now_month
      12-(dob_month-now_month).abs
    else
      now_month-dob_month
    end
  end

  # This method gets the years elapsed since origin_time
  def years_from_origin_time
    dob_years = origin_time.strftime('%Y').to_i
    now_years = Time.now.strftime('%Y').to_i
    dob_month = origin_time.strftime('%m').to_i
    now_month = Time.now.strftime('%m').to_i
    if dob_month == now_month
      dob_date = origin_time.strftime('%d').to_i
      now_date = Time.now.strftime('%d').to_i
      if now_date > dob_date
        now_years - dob_years - 1
      else
        now_years - dob_years
      end
    elsif dob_month > now_month
      now_years - dob_years - 1
    else
      now_years - dob_years
    end
  end
end