from logging import warning
import os
import json
import subprocess
from robot.libraries.BuiltIn import BuiltIn
from robot.api.deco import keyword
from robot.api import logger

class Pa11yLibrary():

    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    ROBOT_LIBRARY_VERSION = '1.0.0'

    def __init__(self):
        self.counter = 0
        # Get the output folder:
        built_in = BuiltIn()
        self.output_dir = built_in.get_variable_value('${OUTPUT DIR}')
        
    
    @keyword("Run Pa11y On URL")
    def run_pa11y_on_url(self, url):
        """
        Runs the PA11y accessibility evaluation tool on a given URL and collects the report.
        |  = Attribute =  |  = Description =  |
        | URL             |  The URL to run pa11y on. |
        """
        if not url:
                raise Exception("No URL Passed to run_pa11y_on_url!")

        # Counter for distinguishing screenshots:
        self.counter += 1
        screen_rel = f'pa11y-screenshot-{self.counter}.png'
        screen = f'{self.output_dir}/{screen_rel}'
        # Remove file if it already exists:
        if os.path.exists(screen):
                os.remove(screen)

        # Run the command:
        logger.info(f"Running Pa11y on {url}...")
        # e.g. pa11y --reporter json --runner axe --runner htmlcs --include-warnings https://www.webarchive.org.uk/
        p = subprocess.run(['pa11y', '--reporter', 'json', '--runner', 'axe', '--runner', 'htmlcs', '--include-warnings', '--screen-capture', screen, url ], capture_output=True)

        # Record results:
        report_rel = f'pa11y-report-{self.counter}.json'
        report_path = f'{self.output_dir}/{report_rel}'
        if p.stdout:
                results = json.loads(p.stdout)
                errors = 0
                warnings = 0
                for issue in results:
                        if issue['type'] == 'error':
                                errors += 1
                        else:
                                warnings += 1

                # Write to a file as pretty-printed JSON:
                with open(report_path, 'w') as outfile:
                        json.dump(results, outfile, indent=2)

                # Summarize:
                if errors > 0:
                        logger.error(f'Pa11y found <a href="{report_rel}">{errors} errors and {warnings} warnings!</a>', html=True)
                elif warnings > 0:
                        logger.warn(f'Pa11y found <a href="{report_rel}">{warnings} warnings!</a>', html=True)

        # Include screenshot in report:
        logger.info(f'Screenshot from just before Pa11y ran: <a title="Screenshot from Pa11y processing." href="{screen_rel}"><img src="{screen_rel}" style="max-width: 50%;"/></a>', html=True)

        # Report overall outcome:
        if p.returncode != 0:
                if p.stderr:
                        logger.error(p.stderr)
                raise Exception("Pa11y Accessibility Checks Failed! Please check the report or perform a manual assessment.")
