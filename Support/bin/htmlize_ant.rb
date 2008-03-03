#!/usr/bin/env ruby

# This is a modified version of rake_helper.rb from the Ruby on Rails bundle.
# Its copyright 
# Copyright:
#   (c) 2006 InquiryLabs, Inc.
#   Visit us at http://inquirylabs.com/
# Original Author: Duane Johnson (duane.johnson@gmail.com)

bundle_lib = ENV['TM_BUNDLE_SUPPORT'] + '/lib'
$LOAD_PATH.unshift(bundle_lib) if ENV['TM_BUNDLE_SUPPORT'] and !$LOAD_PATH.include?(bundle_lib)

require 'text_mate'
require "#{ENV["TM_SUPPORT_PATH"]}/lib/escape"
require "#{ENV["TM_SUPPORT_PATH"]}/lib/web_preview"

Dir.chdir TextMate.project_directory
task = ARGV.shift
command = "ant #{task}"
puts html_head(:window_title => "#{task} — RakeMate", :page_title => 'RakeMate', :sub_title => 'Rake')
puts <<-HTML
    <div id="report_title">Rake Report</div>
    <div id="rake_command">#{command}</div>
    <div>
			<pre><!-- <strong>RakeMate</strong> -->
<div style="white-space: normal; -khtml-nbsp-mode: space; -khtml-line-break: after-white-space;">
HTML
$stdout.flush
output = `#{command}`
report = ""
compile_error_re = /(\/.*?):(\d+):\s*(.*)$/
output.to_a.each do |line|
  if (match = line.match(compile_error_re)) then
    fn = match[1]
    if defined?(proj_dir) and fn.startswith(proj_dir)
      short_name = fn[len(proj_dir)]
    else
      short_name = fn
      colInd = 0
    end
    report += '%s<a href="txmt://open?url=file://%s&line=%s&column=%d">%s:%s: %s</a>' % [
        match[0], fn, match[2], colInd, short_name, match[2], match[3]]
    report += "<b>#{line}</b>" + "<br />"
  else
    report += line + "<br />"
  end
end
report += "<div class='done'>Done</div>"
puts report
puts <<-HTML
      </div>
    </div>
  </body>
</html>
HTML
