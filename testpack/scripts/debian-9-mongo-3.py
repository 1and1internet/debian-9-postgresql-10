#!/usr/bin/env python3

import unittest
from selenium import webdriver


class Test1and1MongoImage(Test1and1Common):

    # <tests to run>

    def test_docker_logs(self):
        expected_log_lines = [
            "Process 'mongod' changed state to 'RUNNING'"
        ]
        container_logs = self.container.logs().decode('utf-8')
        for expected_log_line in expected_log_lines:
            self.assertTrue(
                container_logs.find(expected_log_line) > -1,
                msg="Docker log line missing: %s from (%s)" % (expected_log_line, container_logs)
            )

    def test_mongo_package(self):
        self.assertPackageIsInstalled("mongodb-org")

    # </tests to run>

if __name__ == '__main__':
    unittest.main(verbosity=1)
