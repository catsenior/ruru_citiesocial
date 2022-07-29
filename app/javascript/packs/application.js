import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

const images = require.context('../images', true)
const imagePath = (name) => images(name, true)

import "controllers"

import 'scripts/frontend';
import 'scripts/shared';

import 'styles/frontend';
import 'styles/shared';
