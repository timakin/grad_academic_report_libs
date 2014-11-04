require File.expand_path('./crunchbase_data_analysis/common', __FILE__)
require File.expand_path('./crunchbase_data_analysis/get_cross_section_csvdata', __FILE__)


module CrunchbaseDataAnalysis
end

CrunchbaseDataAnalysis::GetCrossSectionCsvdata.generate_data
