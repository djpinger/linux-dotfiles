from powerline_shell.utils import BasicSegment
import os


class Segment(BasicSegment):
    def add_to_powerline(self):
        aws_profile = os.environ.get("AWS_ACCOUNT_ROLE")
        if aws_profile:
            self.powerline.append(" %s " % os.path.basename(aws_profile),
                                  self.powerline.theme.AWS_PROFILE_FG,
                                  self.powerline.theme.AWS_PROFILE_BG)
