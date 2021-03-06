#Summary statistics tests
context("Summary stats test")

example<-load.example("example1",F)
data <- example$data
tf <- example$tf
design <- svydesign(~0, data = data)
questionnaire <- example$questionnaire

test_that("var_more_than_n returns FALSE unless the dependent variable has two categories",{
  expect_equal(var_more_than_n(c(NULL,7,7,7), 1),FALSE)
  expect_equal(var_more_than_n(c(NA, 7,7,7), 1),FALSE)
  expect_equal(var_more_than_n(c("d", 7,7,7), 1),TRUE)
  expect_equal(var_more_than_n(c("d", "D"), 1),TRUE) #do we want it to be case sensitive? ideally throw a warning
  expect_equal(var_more_than_n(c("d", "d"), 1),FALSE)
  expect_equal(var_more_than_n(c(NA,NULL), 1),FALSE)
  expect_equal(var_more_than_n(c(7," "), 1),FALSE)
  expect_equal(var_more_than_n(c("  "," "), 1),FALSE)
  expect_equal(var_more_than_n(c(list(), "d"), 1),FALSE)
  # expect_equal(1,2)
  # expect_equal(reduce_single_item_lists(1),1)
  # expect_equal(reduce_single_item_lists("A"),"A")
  # expect_equal(reduce_single_item_lists(list()),list())
  # expect_equal(reduce_single_item_lists(list(1,2,list(1,2))),list(1,2,list(1,2)))
  # expect_equal(1,2)
})


test_that("percent_with_confints_select_one outputs correct",{
  ###This needs to be tested with a dependent var thats select one, one that's select multiple, one that's numeric etc
  expect_is(percent_with_confints_select_one(tf$select_one[1], design = design), "data.frame")
  #expect_error(percent_with_confints_select_one(tf$numeric[1], design = design)) #numerical var, shouldnt throw error
  expect_equal(percent_with_confints_select_one(tf$fake[1], design = design)$dependent.var.value, NA)
  expect_warning(percent_with_confints_select_one(tf$select_multiple[1], design = design), "Question is a select multiple. Please use percent_with_confints_select_multiple instead") # select multiple
  expect_match(names(percent_with_confints_select_one(tf$select_one[1], design = design)), "min",all = FALSE)
  expect_match(names(percent_with_confints_select_one(tf$select_one[1], design = design)), "max",all = FALSE)
})

test_that("percent_with_confints_select_multiple outputs correct",{
  sm.columns <- questionnaire$choices_for_select_multiple(tf$select_multiple[1], data = data)
  expect_is(percent_with_confints_select_multiple(tf$select_multiple[1], sm.columns, design = design), "data.frame")
  expect_warning(percent_with_confints_select_multiple(tf$numeric[1], sm.columns, design = design)) #numerical var
  expect_warning(percent_with_confints_select_multiple(tf$fake[1], sm.columns, design = design)) #nonexistent.var
  expect_warning(percent_with_confints_select_multiple(tf$select_multiple[1], design = design)) # sm columns missing
  expect_(percent_with_confints_select_multiple(tf$select_multiple_NA_heavy[1], design = design)) #numerical var
  expect_match(names(percent_with_confints_select_multiple(tf$select_multiple[1], design = design)), "min",all = FALSE)
  expect_match(names(percent_with_confints_select_multiple(tf$select_multiple[1], design = design)), "max",all = FALSE)
})


test_that("percent_with_confints_select_one_groups all inputs correct",{
  expect_warning(percent_with_confints_select_one_groups(tf$select_one_many_cat[1], tf$select_one[2], design)) ##wrong dependent
  expect_warning(percent_with_confints_select_one_groups(tf$numeric[1], tf$select_one[2], design)) ## wrong dependent
  expect_warning(percent_with_confints_select_one_groups(tf$fake[1], tf$select_one[2], design)) ## wrong dependent
  expect_warning(percent_with_confints_select_one_groups(tf$select_multiple[1], tf$fake[2], design)) ##wrong independent
  expect_warning(percent_with_confints_select_one_groups(tf$select_multiple[1], tf$numeric[2], design)) ## wrong independent
  expect_warning(percent_with_confints_select_one_groups(tf$select_multiple[1], tf$select_multiple[2], design)) ## wrong independent
})

test_that("percent_with_confints_select_mult_groups all outputs correct",{
  sm.columns <- questionnaire$choices_for_select_multiple(tf$select_multiple[1], data = data)
  expect_is(percent_with_confints_select_multiple_groups(tf$select_multiple[1], sm.columns, tf$select_one[2], design), "data.frame")
  expect_named(percent_with_confints_select_multiple_groups(tf$select_multiple[1],sm.columns, tf$select_one[2], design), c("dependent.var","independent.var",
                                                                                                            "dependent.var.value","independent.var.value",
                                                                                                            "numbers","se","min","max"))
  expect_true(is.numeric(percent_with_confints_select_mult_groups(tf$select_multiple[1], sm.columns, tf$select_one[2], design)$numbers))
  expect_false(is.null(percent_with_confints_select_mult_groups(tf$select_multiple[1], tf$select_one[2], design)$numbers))
})


test_that("percent_with_confints_select_one_groups all inputs correct",{
  expect_is(percent_with_confints_select_one_groups(tf$select_one[1], tf$select_one[2], design), "data.frame")
  expect_error(percent_with_confints_select_one_groups(tf$numeric[1], tf$select_one[2], design)) ##wrong dependent
  expect_error(percent_with_confints_select_one_groups(tf$select_multiple[1], tf$select_one[2], design)) ## wrong dependent
  expect_error(percent_with_confints_select_one_groups(tf$select_one[1], tf$numeric[2], design)) ##wrong independent
  expect_error(percent_with_confints_select_one_groups(tf$select_multiple[1], tf$numeric[2], design)) ## wrong independent
  expect_error(percent_with_confints_select_one_groups(tf$select_multiple[1], tf$select_multiple[2], design)) ## wrong independent
})

test_that("percent_with_confints_select_one_groups all outputs correct",{
  expect_is(percent_with_confints_select_one_groups(tf$select_one[1], tf$select_one[2], design), "data.frame")
  expect_named(percent_with_confints_select_one_groups(tf$select_one[1], tf$select_one[2], design), c("dependent.var","independent.var",
                                                                                                      "dependent.var.value","independent.var.value",
                                                                                                      "numbers","se","min","max"))
  expect_true(is.numeric(percent_with_confints_select_one_groups(tf$select_one[1], tf$select_one[2], design)$numbers))
})

test_that("mean_with_confints outputs correct",{
  ###This needs to be tested with a dependent var thats select one, one that's select multiple, one that's numeric etc
  expect_is(percent_with_confints_select_one(tf$select_one[1], design = design), "data.frame")
  #expect_error(percent_with_confints_select_one(tf$numeric[1], design = design)) #numerical var, shouldnt throw error
  expect_error(percent_with_confints_select_one(tf$fake[1], design = design)) #nonexistent.var
  expect_error(percent_with_confints_select_one(tf$select_multiple[1], design = design)) # select multiple
  expect_match(names(percent_with_confints_select_one(tf$select_one[1], design = design)), "min",all = FALSE)
  expect_match(names(percent_with_confints_select_one(tf$select_one[1], design = design)), "max",all = FALSE)
})



