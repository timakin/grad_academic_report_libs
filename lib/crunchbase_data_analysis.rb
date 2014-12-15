require_relative 'crunchbase_data_analysis/common'
#require_relative 'crunchbase_data_analysis/get_cross_section_csvdata'
require_relative 'crunchbase_data_analysis/get_panel_csvdata'

module CrunchbaseDataAnalysis
end

#get_cross = CrunchbaseDataAnalysis::GetCrossSectionCsvdata.new()
#get_cross.generate_data

get_panel = CrunchbaseDataAnalysis::GetPanelCsvdata.new()
get_panel.generate_data