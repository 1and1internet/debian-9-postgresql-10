#!/usr/bin/env python3

import unittest
from selenium import webdriver
from testpack_helper_library.unittests.dockertests import Test1and1Common
import time


class Test1and1Postgresql10Image(Test1and1Common):

    # <tests to run>

    def test_docker_logs(self):
        time.sleep(10)  # Give the db time to initialise
        expected_log_lines = [
            "Process 'postgresql' changed state to 'RUNNING'",
            'listening on IPv4 address "0.0.0.0", port 5432',
            "database system is ready to accept connections",
        ]
        container_logs = self.container.logs().decode('utf-8')
        for expected_log_line in expected_log_lines:
            self.assertTrue(
                container_logs.find(expected_log_line) > -1,
                msg="Docker log line missing: %s from (%s)" % (expected_log_line, container_logs)
            )

    def test_postgresql10_package(self):
        self.assertPackageIsInstalled("postgresql-10")

    # </tests to run>

if __name__ == '__main__':
    unittest.main(verbosity=1)
