# 按字节切分字符串
msg_bytes = msg.encode('utf-8')

for i in range(0, len(msg_bytes), 2048):
  self.wecom.send_msg(content=msg_bytes[i: i + 2048].decode('utf-8'), touser=self.to_user, markdown=False)
