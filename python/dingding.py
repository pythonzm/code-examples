import time
import hmac
import json
import hashlib
import base64
import requests
import urllib.parse

# 群机器人信息
HOOK = 'XXXXXXXXXXXXXXXXXXXXXXXxx'
SECRET = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXx'

# 钉钉接口信息
APPKEY = 'XXXXXXXXXXXXXXXXXXXXXxx'
APPSECRET = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXx'

HEADERS = {'Content-Type': 'application/json'}

USERS = {
    'XXX': 'xxxxxxxxxxxxxxxxx'
}


class Ding:
    def __init__(self):
        self.access_token = self.__get_token

    @property
    def __get_token(self):
        res = requests.get(f'https://oapi.dingtalk.com/gettoken?appkey={APPKEY}&appsecret={APPSECRET}', headers=HEADERS)
        token = res.json().get('access_token')
        return token

    def get_user_id(self, username):
        if username in USERS:
            return USERS.get(username)
        result = self.get_user_list_by_dept()
        for user in result.get('list'):
            if user.get('name') == username:
                return user.get('userid')

        while result.get('has_more'):
            result = self.get_user_list_by_dept(result.get('next_cursor'))
            for user in result.get('list'):
                if user.get('name') == username:
                    return user.get('userid')

    def get_user_list_by_dept(self, cursor=0):
        """
        :param cursor:
        :return:
        """
        data = {
            'dept_id': '555555555',
            'cursor': cursor,
            'size': 30
        }
        result = requests.post(
            f'https://oapi.dingtalk.com/topapi/user/listsimple?access_token={self.access_token}',
            data=json.dumps(data), headers=HEADERS).json().get('result')

        return result

    def get_depts(self):
        data = {
            'dept_id': 1
        }
        result = requests.post(
            f'https://oapi.dingtalk.com/topapi/v2/department/listsub?access_token={self.access_token}',
            data=json.dumps(data), headers=HEADERS).json().get('result')

        return result

    def send_msg(self, project_name, username=None, merge_url=None):
        timestamp = str(round(time.time() * 1000))
        secret_enc = SECRET.encode('utf-8')
        string_to_sign = '{}\n{}'.format(timestamp, SECRET)
        string_to_sign_enc = string_to_sign.encode('utf-8')
        hmac_code = hmac.new(secret_enc, string_to_sign_enc, digestmod=hashlib.sha256).digest()
        sign = urllib.parse.quote_plus(base64.b64encode(hmac_code))

        webhook = f'{HOOK}&timestamp={timestamp}&sign={sign}'

        if username and merge_url:
            user_id = self.get_user_id(username)
            data = {
                "msgtype": "markdown",
                "markdown": {
                    "title": "title",
                    "text": f"### {project_name} 来了 @{user_id} \n > [**点击查看**]({merge_url}) \n"
                },
                "at": {
                    "atUserIds": [
                        user_id
                    ],
                    "isAtAll": False
                }
            }
        requests.post(webhook, data=json.dumps(data), headers=HEADERS)


if __name__ == '__main__':
    d = Ding()
    print(json.dumps(d.get_user_list_by_dept(), ensure_ascii=False))

