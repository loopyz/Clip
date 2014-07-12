import os
import urllib

import jinja2
import webapp2

JINJA_ENVIRONMENT = jinja2.Environment (
	loader=jinja2.FileSystemLoader(os.path.dirname(__file__)),
	extensions=['jinja2.ext.autoescape'],
	autoescape=True)

class LoginPage(webapp2.RequestHandler):
    def get(self):
        template_values = {}
        template = JINJA_ENVIRONMENT.get_template('loginPage.html')
        self.response.out.write(template.render(template_values))

class HomePage(webapp2.RequestHandler):
    def get(self):
        template_values = {}
        template = JINJA_ENVIRONMENT.get_template('home.html')
        self.response.out.write(template.render(template_values))

application = webapp2.WSGIApplication([('/', LoginPage),
                                       ('/home', HomePage),], debug=True)
