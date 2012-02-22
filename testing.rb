require 'rubygems'
require 'benchmark'

HostHeader = 'bogus.dev'
BaseURL    = 'http://localhost'
TestBOC    = '/test.html'
TestURL = BaseURL + TestBOC
N = 500

Metrics = []
def measure(label, &proc)
  Metrics << [label, proc]
end

Metric = Struct.new(:name, :real, :user, :system) do
  def cpu
    user + system
  end

  def other
    real - cpu
  end

  def percent_other
    other / real
  end
end

def collect_result(name, &proc)
  # Run the block once, so our first request (probably) doesn't have a cache miss
  # NB: it may get purged, but since we're using the test BOC, that's unlikely
  proc.call

  # Now run it again, N times
  t = Benchmark.measure { N.times(&proc) }
  Metric.new(name, t.real, t.utime, t.stime)
end

TableHeaderTemplate = (['%-20s' % 'Library'] + ['%-15s']*3).join(' | ') % ['real', 'cpu', 'other']
TableRowTemplate    = (['%-20s'] + ['%.6f (%4s)']*3).join(' | ')

def print_results_line(metric, baseline)
  if metric == baseline
    relative_real = relative_cpu = '----'
  else
    relative_real = percent(metric.real / baseline.real)
    relative_cpu  = percent(metric.cpu  / baseline.cpu)
  end

  puts TableRowTemplate % [
    metric.name,
    metric.real,  relative_real,
    metric.cpu,   relative_cpu,
    metric.other, percent(metric.percent_other),
  ]
end

def percent(num)
  "#{(num*100).to_i}%"
end

require 'test_patron'
require 'test_curb'
require 'test_net_http'
require 'test_typhoeus'
require 'test_excon'

def perform_measurements
  puts '', "n=#{N}", TableHeaderTemplate

  baseline = nil
  Metrics.map do |name, proc|
    metric = collect_result(name, &proc)
    baseline ||= metric
    print_results_line metric, baseline
  end
end

perform_measurements
