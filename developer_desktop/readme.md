# To create the developer desktop used in this lab

# Set your AWS_PROFILE= the correct environmentment as defined in ~/.aws/credentials
	<code>export AWS_PROFILE=css1</code>

# Install packer

	<code>packer verify dev_desktop.json</code>
	<code>packer build dev_desktop.json</code>
