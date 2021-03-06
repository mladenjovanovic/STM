#' Set and Rep Schemes
#'
#' @param reps Numeric vector indicating reps prescription
#' @param adjustment Numeric vector indicating adjustments. Forwarded to \code{progression_table}.
#'     If the \code{progression_table} is \code{\link{RIR_increment}}, \code{adjustment} will be done
#'     using RIR. On the other hand, if \code{\link{perc_drop}} is used, \code{adjustment} will be done
#'     using 1RM percentage
#' @param vertical_planning Vertical planning function. Default is \code{\link{vertical_linear}}
#' @param vertical_planning_control Arguments forwarded to the \code{vertical_planning} function
#' @param progression_table Progression table function. Default is \code{\link{RIR_increment}}
#' @param progression_table_control Arguments forwarded to the \code{progression_table} function
#'
#' @return Data frame with the following columns: \code{reps}, \code{index}, \code{step},
#'     \code{adjustment}, and \code{perc_1RM}.
#'
#' @name set_and_reps_schemes
NULL


#' @describeIn set_and_reps_schemes Generic set and rep scheme.
#'     \code{scheme_generic} is called in all other set and rep schemes - only the default parameters
#'     differ to make easier and quicker schemes writing and groupings
#'
#' @export
#' @examples
#' scheme_generic()
scheme_generic <- function(reps = c(5, 5, 5),
                        adjustment = c(0, 0, 0),
                        vertical_planning = vertical_linear,
                        vertical_planning_control = list(),
                        progression_table = RIR_increment,
                        progression_table_control = list()) {
  progression <- do.call(vertical_planning, c(list(reps = reps), vertical_planning_control))

  loads <- do.call(
    progression_table,
    c(
      list(
        reps = progression$reps,
        step = progression$step,
        adjustment = adjustment
      ),
      progression_table_control
    )
  )

  data.frame(
    reps = progression$reps,
    index = progression$index,
    step = progression$step,
    adjustment = loads$adjustment,
    perc_1RM = loads$perc_1RM
  )
}

#' @describeIn set_and_reps_schemes Wave set and rep scheme
#' @export
#' @examples
#'
#' # Wave set and rep schemes
#' --------------------------
#' scheme_wave()
#'
#' scheme_wave(
#'   reps = c(8, 6, 4, 8, 6, 4),
#'   vertical_planning = vertical_block,
#'   progression_table = perc_drop,
#'   progression_table_control = list(type = "ballistic"))
#'
#' # Adjusted second wave
#' # and using 3 steps progression
#' scheme_wave(
#'   reps = c(8, 6, 4, 8, 6, 4),
#'   # Adjusting using lower %1RM (Perc_Drop method used)
#'   adjustment = c(0, 0, 0, -0.1, -0.1, -0.1),
#'   vertical_planning = vertical_linear,
#'   vertical_planning_control = list(reps_change = c(0, -2, -4)),
#'   progression_table = perc_drop,
#'   progression_table_control = list(volume = "extensive"))
#'
#' # Adjusted using RIR inc
#' # This time we adjust first wave as well, first two sets easier
#' scheme_wave(
#'   reps = c(8, 6, 4, 8, 6, 4),
#'   # Adjusting using lower %1RM (RIR Increment method used)
#'   adjustment = c(4, 2, 0, 6, 4, 2),
#'   vertical_planning = vertical_linear,
#'   vertical_planning_control = list(reps_change = c(0, -2, -4)),
#'   progression_table = RIR_increment,
#'   progression_table_control = list(volume = "extensive"))
scheme_wave <- function(reps = c(10, 8, 6, 10, 8, 6),
                        adjustment = c(4, 2, 0, 6, 4, 2),
                        vertical_planning = vertical_linear,
                        vertical_planning_control = list(),
                        progression_table = RIR_increment,
                        progression_table_control = list(volume = "extensive")) {

  scheme_generic(
    reps = reps,
    adjustment = adjustment,
    vertical_planning = vertical_planning,
    vertical_planning_control = vertical_planning_control,
    progression_table = progression_table,
    progression_table_control = progression_table_control
    )

}

#' @describeIn set_and_reps_schemes Plateau set and rep scheme
#' @export
#' @examples
#'
#' # Plateau set and rep schemes
#' --------------------------
#' scheme_plateau()
#'
#' scheme_plateau(
#'   reps = c(3, 3, 3),
#'   progression_table_control = list(type = "ballistic"))
scheme_plateau <- function(reps = c(5, 5, 5, 5),
                        vertical_planning = vertical_constant,
                        vertical_planning_control = list(),
                        progression_table = RIR_increment,
                        progression_table_control = list(volume = "extensive")) {

  scheme_generic(
    reps = reps,
    # No adjustment with plateau
    adjustment = 0,
    vertical_planning = vertical_planning,
    vertical_planning_control = vertical_planning_control,
    progression_table = progression_table,
    progression_table_control = progression_table_control
  )

}


#' @describeIn set_and_reps_schemes Step set and rep scheme
#' @export
#' @examples
#'
#' # Step set and rep schemes
#' --------------------------
#' scheme_step()
#'
#' scheme_step(
#'   reps = c(2, 2, 2),
#'   adjustment = c(-0.1, -0.05, 0),
#'   vertical_planning = vertical_linear_reverse,
#'   progression_table_control = list(type = "ballistic")
#' )
scheme_step <- function(reps = c(5, 5, 5, 5),
                        adjustment = c(-0.3, -0.2, -0.1, 0),
                           vertical_planning = vertical_constant,
                           vertical_planning_control = list(),
                           progression_table = perc_drop,
                           progression_table_control = list(volume = "normal")) {

  scheme_generic(
    reps = reps,
    adjustment = adjustment,
    vertical_planning = vertical_planning,
    vertical_planning_control = vertical_planning_control,
    progression_table = progression_table,
    progression_table_control = progression_table_control
  )

}

#' @describeIn set_and_reps_schemes Reverse Step set and rep scheme
#' @export
#' @examples
#'
#' # Reverse Step set and rep schemes
#' --------------------------
#' scheme_step_reverse()
scheme_step_reverse <- function(reps = c(10, 10, 10, 10),
                        adjustment = c(0, 3, 6, 9),
                        vertical_planning = vertical_constant,
                        vertical_planning_control = list(),
                        progression_table = RIR_increment,
                        progression_table_control = list(volume = "normal")) {

  scheme_generic(
    reps = reps,
    adjustment = adjustment,
    vertical_planning = vertical_planning,
    vertical_planning_control = vertical_planning_control,
    progression_table = progression_table,
    progression_table_control = progression_table_control
  )

}

#' @describeIn set_and_reps_schemes Descending Wave set and rep scheme
#' @export
#' @examples
#'
#' # Descending Wave set and rep schemes
#' --------------------------
#' scheme_wave_descending()
scheme_wave_descending <- function(reps = c(6, 8, 10, 6, 8, 10),
                        adjustment = c(4, 2, 0, 6, 4, 2),
                        vertical_planning = vertical_linear,
                        vertical_planning_control = list(),
                        progression_table = RIR_increment,
                        progression_table_control = list(volume = "extensive")) {

  scheme_generic(
    reps = reps,
    adjustment = adjustment,
    vertical_planning = vertical_planning,
    vertical_planning_control = vertical_planning_control,
    progression_table = progression_table,
    progression_table_control = progression_table_control
  )

}

#' @describeIn set_and_reps_schemes Light-Heavy set and rep scheme
#' @export
#' @examples
#'
#' # Light-Heavy set and rep schemes
#' --------------------------
#' scheme_light_heavy()
scheme_light_heavy <- function(reps = c(6, 3, 6, 3, 6, 3),
                                   adjustment = c(0, -0.2, 0, -0.2, 0, -0.2),
                                   vertical_planning = vertical_constant,
                                   vertical_planning_control = list(),
                                   progression_table = perc_drop,
                                   progression_table_control = list(volume = "normal")) {

  scheme_generic(
    reps = reps,
    adjustment = adjustment,
    vertical_planning = vertical_planning,
    vertical_planning_control = vertical_planning_control,
    progression_table = progression_table,
    progression_table_control = progression_table_control
  )

}


#' @describeIn set_and_reps_schemes Pyramid set and rep scheme
#' @export
#' @examples
#'
#' # Pyramid set and rep schemes
#' --------------------------
#' scheme_pyramid()
scheme_pyramid <- function(reps = c(12, 10, 8, 8, 10, 12),
                               adjustment = 0,
                               vertical_planning = vertical_linear,
                               vertical_planning_control = list(reps_change = c(0, -2, -4, -6)),
                               progression_table = RIR_increment,
                               progression_table_control = list(volume = "extensive")) {

  scheme_generic(
    reps = reps,
    adjustment = adjustment,
    vertical_planning = vertical_planning,
    vertical_planning_control = vertical_planning_control,
    progression_table = progression_table,
    progression_table_control = progression_table_control
  )

}


#' @describeIn set_and_reps_schemes Reverse Pyramid set and rep scheme
#' @export
#' @examples
#'
#' # Reverse Pyramid set and rep schemes
#' --------------------------
#' scheme_pyramid_reverse()
scheme_pyramid_reverse <- function(reps = c(8, 10, 12, 12, 10, 8),
                           adjustment = 0,
                           vertical_planning = vertical_linear,
                           vertical_planning_control = list(reps_change = c(0, -2, -4, -6)),
                           progression_table = RIR_increment,
                           progression_table_control = list(volume = "extensive")) {

  scheme_generic(
    reps = reps,
    adjustment = adjustment,
    vertical_planning = vertical_planning,
    vertical_planning_control = vertical_planning_control,
    progression_table = progression_table,
    progression_table_control = progression_table_control
  )

}

#' @describeIn set_and_reps_schemes Rep Accumulation set and rep scheme
#' @export
#' @examples
#'
#' # Rep Accumulation set and rep schemes
#' --------------------------
#' scheme_rep_acc()
scheme_rep_acc <- function(reps = c(7, 7, 7),
                                   adjustment = 0,
                                   #vertical_planning = vertical_planning,
                                   vertical_planning_control = list(step = rep(-3, 4)),
                                   progression_table = RIR_increment,
                                   progression_table_control = list(volume = "extensive")) {

  scheme_df <- scheme_generic(
    reps = reps,
    adjustment = adjustment,
    vertical_planning = vertical_planning,
    vertical_planning_control = vertical_planning_control,
    progression_table = progression_table,
    progression_table_control = progression_table_control
  )

  scheme_df$reps <- scheme_df$reps + scheme_df$index - 1

  scheme_df
}
