import os
import sys
import threading
import time
import json
import re

from locust import HttpLocust, TaskSet, task, events
from locust.exception import LocustError

_serverHost = "@@SERVER_HOST@@"

_userNames = []
_userPasswords = []
_currentUser = 0
_userLock = threading.RLock()

jobBaseName = "@@JOB_BASE_NAME@@"
buildNumber = "@@BUILD_NUMBER@@"

usenv = os.getenv("USERS_PROPERTIES")
lines = usenv.split('\n')

_users = len(lines)

for u in lines:
    up = u.split('=')
    _userNames.append(up[0])
    _userPasswords.append(up[1])


class UserScenario(TaskSet):
    taskUser = -1
    taskUserName = ""
    taskUserPassword = ""

    start = -1
    stop = -1

    def on_start(self):
        global _currentUser, _users, _userLock, _userNames, _userPasswords
        _userLock.acquire()
        self.taskUser = _currentUser
        if _currentUser < _users - 1:
            _currentUser += 1
        else:
            _currentUser = 0
        _userLock.release()
        self.taskUserName = _userNames[self.taskUser]
        self.taskUserPassword = _userPasswords[self.taskUser]

    def _reset_timer(self):
        self.start = time.time()

    def _tick_timer(self):
        self.stop = time.time()
        ret_val = (self.stop - self.start) * 1000
        self.start = self.stop
        return ret_val

    def _report_success(self, category, name, response_time):
        events.request_success.fire(
            request_type=category,
            name=name,
            response_time=response_time,
            response_length=0
        )

    def _report_failure(self, category, name, response_time, msg):
        events.request_failure.fire(
            request_type=category,
            name=name,
            response_time=response_time,
            exception=LocustError(msg)
        )

    @task
    def runGet(self):
        self.client.get(
            "/get?user=" + self.taskUserName,
            name="get-"+self.taskUserName
        )

    @task
    def example(self):
        category = "example"

        # first metric in the task (passed)
        metric = "metric-1"
        # start measuring
        self._reset_timer()

        # do something
        time.sleep(0.03)

        # stop measuring and report
        self._report_success(category, metric, self._tick_timer())

        # second metric in the task (failed)
        metric = "metric-2"
        # start measuring
        self._reset_timer()

        # do something that causes failure
        time.sleep(0.05)

        # stop measuring and report
        self._report_failure(
            category, metric, self._tick_timer(), "metric 2 failed")


class UserLocust(HttpLocust):
    task_set = UserScenario
    host = _serverHost
    min_wait = 1000
    max_wait = 1000
