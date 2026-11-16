  service do
    run [opt_bin/"deadband", "daemon"]
    keep_alive true
    error_log_path var/"log/deadband.log"
  end
