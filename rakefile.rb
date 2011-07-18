require 'zip/zip'
require 'zip/zipfilesystem'
require  File.dirname(__FILE__) +'\\dnrMailer.rb'

	@mailServer = ''
	@mailRecipient =''
	@mailSubject = ''
	@mailContent = ''
	@packageName = ''
	
task :default , :mailServer, :mailRecipient, :mailSubject, :mailContent,:packageName , :needs=> [:init,:clean, :compile,:zip,:sendByMail] do |t, args | 
	args.with_defaults(:mailServer => nil, :mailRecipient => nil, :mailSubject => 'New build available', :mailContent => 'Here is my message content', :packageName => 'package.zip')
	
end

task :init do | t, args|
	@mailServer, @mailRecipient, @mailSubject, @mailContent, @packageName = args.mailServer, args.mailRecipient, args.mailSubject, args.mailContent, args.packageName
end


task :clean do
	puts '#Starting Cleanup'
	puts ' - Cleaning output folder...'

	FileUtils.rm_rf('\\bin')
	if(File.exists?('package\\' + @packageName)) then
		puts ' - Removing package file'
		FileUtils.rm('package\\'+ @packageName)
	end
	puts '#Cleanup finished'
end

task :compile do
	puts '#Starting build process (using MSBuild)...'
	params = '/t:Build /nologo /v:q /p:Configuration=Debug /p:OutputPath="..\..\..\bin" src\\ConsoleApplication1\\ConsoleApplication1.sln'
	msbuild = 'C:\\Windows\\Microsoft.NET\\Framework\\v4.0.30319\\MSBuild.exe'

	sh "#{msbuild} #{params}"
	
	puts '#Build finished'
end

task :zip do
	puts '#Starting packaging process ...'

	binaries = FileList.new('bin/**/*.*')
	documents = FileList.new('doc/**/*.*')
	Zip::ZipFile.open('package\\' + @packageName,'w') do |zip|
		puts ' - Packaging Binaries...'
		binaries.each do | binaryFile | 
			puts " - - Adding #{binaryFile} to zip (Binary)"
			zip.add(File.basename(binaryFile),binaryFile)
		end
		puts ' - Packaging Documents...'
		documents.each do | docFile |
			puts " - - Adding #{docFile} to zip (Document)"
			zip.add(docFile,docFile)
		end	
	end
	puts '#Packaging finished'

end

task :sendByMail do
	puts '#Starting mail procesing ...'
	from = 'foo@bar.com'
	DotNetRocksMailer.send_email from,@mailRecipient,@mailSubject, @mailContent, 'package\\' + @packageName, @mailServer
	puts '#Mail has been sent'
end
