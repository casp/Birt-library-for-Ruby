require "fileutils"

#  require 'birt_report'
#  obj = GeneratorReport.new
#  obj.create_report(2057,'pdf','reporte',:consulta_id=>"237")
#

class GeneratorReport

 REPORT_TEMPLATE_PATH          = File.join(RAILS_ROOT,'app','reports')
 REPORT_REPOSITORY_VPATH       = File.join(RAILS_ROOT,'public','reports')
 BIRT_GENERATOR                = File.join(ENV['BIRT_HOME'], 'ReportEngine','genReport.sh')


  def  create_report(user_id , format , name_report, option={})

   report_path                        = File.join(REPORT_TEMPLATE_PATH,"#{name_report}.rptdesign")
   report_repository_path             = File.join(REPORT_REPOSITORY_VPATH,user_id.to_s,format.to_s)
   name_out_report                    = "#{name_report}_#{Time.now.strftime('%Y%m%d%H%M%S')}.#{format}"
   report_out_path                    =  File.join(report_repository_path,name_out_report)
   commands                           = "sh #{BIRT_GENERATOR}"
   FileUtils.mkpath(report_repository_path) unless File.directory?(report_repository_path)
   parameters                         = option.inject("") do |r,e|
                                                            %Q(#{r} -p #{e[0]}=#{e[1]})
                                                          end

   commands  << "  #{parameters} "
   commands  << " -l es"
   commands  << " -f  #{format} "
   commands  << " -o #{report_out_path}"
   commands  << " #{report_path}"

    RAILS_DEFAULT_LOGGER.info("BIRT: #{commands}")

    result = %x(#{commands})
    result = report_out_path if $?.exitstatus == 0

    "[#{$?.exitstatus}] #{result}"
    return name_out_report
  end

end

