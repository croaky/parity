require File.join(File.dirname(__FILE__), '..', 'lib', 'parity')

describe Parity::Backup do
  it "restores backups to development" do
    allow(IO).to receive(:read).and_return(database_fixture)
    allow(Kernel).to receive(:system)

    Parity::Backup.new(from: "production", to: "development").restore

    expect(Kernel).to have_received(:system).with(curl_piped_to_pg_restore)
  end

  it "restores backups to staging" do
    allow(Kernel).to receive(:system)

    Parity::Backup.new(from: "production", to: "staging").restore

    expect(Kernel).to have_received(:system).with(heroku_pass_through)
  end

  it "passes additional arguments to the subcommand" do
    allow(Kernel).to receive(:system)

    Parity::Backup.new(
      from: "production",
      to: "staging",
      additional_args: "--confirm thisismyapp-staging",
    ).restore

    expect(Kernel).
      to have_received(:system).with(additional_argument_pass_through)
  end

  def database_fixture
    IO.read(database_fixture_path)
  end

  def database_fixture_path
    File.join(File.dirname(__FILE__), 'fixtures', 'database.yml')
  end

  def curl_piped_to_pg_restore
    "curl -s `heroku pg:backups public-url --remote production` | #{pg_restore}"
  end

  def pg_restore
    "pg_restore --verbose --clean --no-acl --no-owner -d parity_development"
  end

  def heroku_pass_through
    "heroku pg:backups restore `heroku pg:backups public-url "\
      "--remote production` DATABASE --remote staging "
  end

  def additional_argument_pass_through
    "heroku pg:backups restore `heroku pg:backups public-url "\
      "--remote production` DATABASE --remote staging "\
      "--confirm thisismyapp-staging"
  end
end
