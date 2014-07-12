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

class CreateCampaignPage(webapp2.RequestHandler):
    def get(self):
        template_values = {}
        template = JINJA_ENVIRONMENT.get_template('createCampaignPage.html')
        self.response.out.write(template.render(template_values))

class ViewCampaignPage(webapp2.RequestHandler):
    def get(self):
        query_string = self.request.get('id')
        template_values = {'query_string':query_string}
        template = JINJA_ENVIRONMENT.get_template('viewCampaignPage.html')
        self.response.out.write(template.render(template_values))

application = webapp2.WSGIApplication([('/', LoginPage),
                                       ('/home', HomePage),
                                       ('/createCampaign', CreateCampaignPage),
                                       ('/viewCampaign', ViewCampaignPage),], debug=True)
