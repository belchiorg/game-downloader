FROM python:3.12-slim

RUN pip install --no-cache-dir rclone-python internetarchive && \
  apt-get update && \
  apt-get install -y --no-install-recommends rclone curl p7zip-full && \
  rm -rf /var/lib/apt/lists/*

COPY download.sh /usr/local/bin/download.sh
RUN chmod +x /usr/local/bin/download.sh

ENTRYPOINT ["/usr/local/bin/download.sh"]