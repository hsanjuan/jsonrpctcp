# Copyright (C) 2015 Hector Sanjuan

# This file is part of Jsonrpctcp.

# Jsonrpctcp is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Jsonrpctcp is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with Jsonrpctcp.  If not, see <http://www.gnu.org/licenses/>

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "yard"
require "yard/rake/yardoc_task"

RSpec::Core::RakeTask.new(:spec) do |t|
  #
end

YARD::Rake::YardocTask.new(:yard)

task :doc => :yard
task :test => :spec
task :default => [:spec, :doc]
