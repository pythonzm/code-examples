class BaseCustomException(Exception):
    def __init__(self, error_msg):
        super().__init__(self)
        self.error_msg = error_msg

    def __str__(self):
        return f"Base异常！{self.error_msg}"


class OtherException(BaseCustomException):
    def __init__(self, error_msg):
        self.error_msg = f"Other失败：{error_msg}"
