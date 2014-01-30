class Build

  def self.from_test_suites(test_suites)
    test_suites
      .group_by(&:build_id)
      .map { |build_id, ts| new(build_id, ts) }
      .sort_by(&:id)
      .reverse
  end

  def initialize(id, test_suites)
    @id = id
    @test_suites = test_suites
  end

  attr_reader :id

  def passed_count;  sum(:passed_count);  end
  def failed_count;  sum(:failed_count);  end
  def pending_count; sum(:pending_count); end
  def total_count;   sum(:total_count);   end

  def status
    'passed'
  end

  def started_at
    @test_suites.first.started_at
  end

  private

  def sum(counter)
    @test_suites.inject(0) {|sum, ts| sum + ts[counter] }
  end

end
