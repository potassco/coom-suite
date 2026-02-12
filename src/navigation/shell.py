"""
Module implementing a command line interface for the navigatior class.
"""

import argparse
import cmd

from navigation.navigator import Navigator
from navigation.utils.output import (
    print_assumptions,
    print_model,
    print_models,
    print_rules,
    print_weight,
    print_weighted_facets,
)
from navigation.utils.parsing import _parse_args, _parse_known_args, _parse_models


class NavigatorShell(cmd.Cmd):
    """
    Interactive shell for navigating solutions of logic programs.
    """

    prompt = "(nav) "
    ALIASES = {
        "q": "quit",
        "exit": "quit",
    }

    def __init__(self, program: str | None = None):
        super().__init__()
        self.nav = Navigator()
        print("Navigator CLI - type 'help' or '?' for commands")
        if program:
            self.nav.load(program)

    def default(self, line):
        cmd, *rest = line.split(maxsplit=1)

        if cmd in self.ALIASES:
            new_line = self.ALIASES[cmd]
            if rest:
                new_line += rest[0]
            return self.onecmd(new_line)

        print(f"unknown command {cmd}")

    def do_load(self, arg):
        """load FILE - load a logic program"""
        parser = argparse.ArgumentParser(prog="load")
        parser.add_argument("file")
        ns = _parse_args(parser, arg)
        if ns:
            self.nav.load(ns.file)

    # CONFIGURATION ####################

    def do_enable_optimization(self, arg):
        """enable_optimization - enable optimization while solving"""
        self.nav.enable_optimization()

    def do_disable_optimization(self, arg):
        """disable_optimization - disable optimization while solving"""
        self.nav.disable_optimization()

    # SOLVING ##########################

    def do_solve(self, arg):
        """solve [N] - compute N models of the program (default: 1)"""
        parser = argparse.ArgumentParser(prog="solve")
        parser.add_argument("n", nargs="?", type=int, default=1)
        ns = _parse_args(parser, arg)
        if ns:
            models = self.nav.compute_models(ns.n)
            print_models(models)

    def do_browse(self, arg):
        """browse - show next model"""
        model = self.nav.browse_models()
        if model is None:
            print("no more models")
        else:
            print_model(model)

    # BRAVE/CAUTIOUS CONSEQUENCES ######

    def do_brave(self, arg):
        """brave - compute brave consequences"""
        res = self.nav.compute_brave_consequences()
        print_model(res)

    def do_cautious(self, arg):
        """cautious - compute cautious consequences"""
        res = self.nav.compute_cautious_consequences()
        print_model(res)

    def do_facets(self, arg):
        """facets - compute facets"""
        res = self.nav.compute_facets()
        print_model(res)

    def do_facet_weight(self, arg):
        """facet_weight ATOM [--absolute] - compute the absolute or relative weight of an atom (default: relative)"""
        parser = argparse.ArgumentParser(prog="facet-weight")
        parser.add_argument("atom")
        parser.add_argument("--absolute", "-a", action="store_true")
        ns = _parse_args(parser, arg)
        if ns:
            w = self.nav.compute_facet_weight(ns.atom, absolute=ns.absolute)
            print_weight(w)

    def do_weighted_facets(self, arg):
        """weighted_facets -  compute the weighted facets (default: relative weight)"""
        parser = argparse.ArgumentParser(prog="weighted-facets")
        parser.add_argument("--absolute", "-a", action="store_true")
        ns = _parse_args(parser, arg)
        if ns:
            res = self.nav.compute_weighted_facets(absolute=ns.absolute)
            print_weighted_facets(res)

    # SIMILAR/DIVERSE MODELS ###########

    def do_diverse(self, arg):
        """diverse [N] - compute N diverse models (default: 1)"""
        parser = argparse.ArgumentParser(prog="diverse")
        parser.add_argument("n", nargs="?", type=int, default=1)
        parser.add_argument("--init", "-i", nargs="*", metavar="MODEL", help="Initial models in form {a,b,c}")
        ns = _parse_args(parser, arg)
        if not ns:
            return

        try:
            initial_models = _parse_models(ns.init)
        except ValueError as e:
            print(e)
            return

        if initial_models:
            print("initial models:")
            print_models(initial_models)

        models = self.nav.compute_diverse_models(ns.n, initial_models)
        print_models(models)

    def do_similar(self, arg):
        """similar [N] - compute N similar models (default: 1)"""
        parser = argparse.ArgumentParser(prog="similar")
        parser.add_argument("n", nargs="?", type=int, default=1)
        parser.add_argument("--init", "-i", nargs="*", metavar="MODEL", help='Initial models in form "{a, b, c}"')
        ns = _parse_args(parser, arg)
        if not ns:
            return

        try:
            initial_models = _parse_models(ns.init)
        except ValueError as e:
            print(e)
            return

        models = self.nav.compute_similar_models(ns.n, initial_models)
        print_models(models)

    # ASSUMPTIONS ######################

    def do_assume(self, arg):
        """assume [not] ATOM - add an assumption"""
        parser = argparse.ArgumentParser(prog="assume")
        parser.add_argument("sign", nargs="?", choices=["not"])
        parser.add_argument("atom")
        ns = _parse_args(parser, arg)
        if ns:
            self.nav.add_assumption(ns.atom, False if ns.sign == "not" else True)

    def do_remove_assumption(self, arg):
        """remove_assumption [not] ATOM - remove an assumption"""
        parser = argparse.ArgumentParser(prog="remove_assumption")
        parser.add_argument("sign", nargs="?", choices=["not"])
        parser.add_argument("atom")
        ns = _parse_args(parser, arg)
        if ns:
            self.nav.remove_assumption(ns.atom, False if ns.sign == "not" else True)

    def do_clear_assumptions(self, arg):
        """clear_assumptions - clear all assumptions"""
        self.nav.clear_assumptions()

    def do_assumptions(self, arg):
        """assumptions - list the current assumptions"""
        print_assumptions(self.nav.get_assumptions())

    def do_add_rule(self, arg):
        """add_rule RULE [--permanent] - add a rule to the program"""
        parser = argparse.ArgumentParser(prog="add-rule")
        parser.add_argument("--permanent", "-p", action="store_true")
        ns, rest = _parse_known_args(parser, arg)

        if ns is None:
            return

        rule = " ".join(rest)

        if not rule:
            print("error: no rule provided")
            return

        self.nav.add_rule(rule, permanent=ns.permanent)

    def do_add_constraint(self, arg):
        """add_constraint CONSTRAINT [--permanent] - add a constraint to the program"""
        parser = argparse.ArgumentParser(prog="add-constraint")
        parser.add_argument("--permanent", "-p", action="store_true")
        ns, rest = _parse_known_args(parser, arg)

        if ns is None:
            return

        constraint = " ".join(rest)

        if not constraint:
            print("error: no constraint provided")
            return

        self.nav.add_constraint(constraint, permanent=ns.permanent)

    def do_activate_rule(self, arg):
        """activate_rule RULE - activate RULE"""
        self.nav.activate_rule(arg)

    def do_deactivate_rule(self, arg):
        """deactivate_rule RULE - deactivate RULE"""
        self.nav.deactivate_rule(arg)

    def do_rules(self, arg):
        """rules - list the added (non-permanent) rules"""
        res = self.nav.get_rules()
        print(res)
        print_rules(res)

    def do_quit(self, arg):
        """quit"""
        return True

    def emptyline(self):
        """pass on emptyline"""

    def run_script(self, filename):
        """execute a script of commands"""
        with open(filename, encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith("#"):
                    continue

                print(f"{self.prompt}{line}")

                self.onecmd(line)
