
"use client";

import { Navigation } from "@/components/Navigation";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Progress } from "@/components/ui/progress";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Trophy, Target, TrendingUp, Plus, Calendar } from "lucide-react";
import { Badge } from "@/components/ui/badge";

export default function GoalsPage() {
  const activeGoals = [
    { id: 1, title: "Weight Management", type: "Target Weight", current: 82, target: 78, unit: "kg", deadline: "Dec 30", category: "Physical" },
    { id: 2, title: "Training Consistency", type: "Sessions per week", current: 3, target: 5, unit: "sessions", deadline: "Ongoing", category: "Discipline" },
    { id: 3, title: "Master High Roundhouse", type: "Form Level", current: 65, target: 100, unit: "%", deadline: "Jan 15", category: "Technique" },
  ];

  return (
    <div className="min-h-screen pb-24 md:pt-20">
      <Navigation />
      <main className="max-w-4xl mx-auto px-4 py-8 space-y-8">
        <header className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div>
            <h1 className="text-4xl font-headline font-bold text-primary">YOUR MILESTONES</h1>
            <p className="text-muted-foreground">Track your progress and conquer new heights.</p>
          </div>
          <Button className="electric-glow"><Plus className="mr-2 w-4 h-4" /> ADD NEW GOAL</Button>
        </header>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <Card className="bg-primary/5 border-primary/20">
            <CardContent className="pt-6 text-center">
              <Trophy className="w-10 h-10 text-primary mx-auto mb-2" />
              <div className="text-2xl font-bold">12</div>
              <div className="text-xs text-muted-foreground uppercase tracking-widest">Completed Goals</div>
            </CardContent>
          </Card>
          <Card className="bg-accent/5 border-accent/20">
            <CardContent className="pt-6 text-center">
              <Target className="w-10 h-10 text-accent mx-auto mb-2" />
              <div className="text-2xl font-bold">3</div>
              <div className="text-xs text-muted-foreground uppercase tracking-widest">Active Challenges</div>
            </CardContent>
          </Card>
          <Card className="bg-muted border-border">
            <CardContent className="pt-6 text-center">
              <TrendingUp className="w-10 h-10 text-muted-foreground mx-auto mb-2" />
              <div className="text-2xl font-bold">84%</div>
              <div className="text-xs text-muted-foreground uppercase tracking-widest">Avg Completion Rate</div>
            </CardContent>
          </Card>
        </div>

        <div className="space-y-6">
          <h2 className="text-2xl font-headline font-bold">ACTIVE GOALS</h2>
          <div className="grid gap-6">
            {activeGoals.map(goal => (
              <Card key={goal.id} className="group hover:border-primary/40 transition-all duration-300">
                <CardContent className="p-6">
                  <div className="flex flex-col md:flex-row gap-6 md:items-center">
                    <div className="w-12 h-12 rounded-lg bg-muted flex items-center justify-center text-primary group-hover:bg-primary/10 transition-colors shrink-0">
                      <Target className="w-6 h-6" />
                    </div>
                    <div className="flex-1 space-y-4">
                      <div className="flex flex-col md:flex-row md:items-center justify-between gap-2">
                        <div>
                          <Badge variant="outline" className="mb-1 text-[10px] text-primary border-primary/20">{goal.category}</Badge>
                          <h3 className="text-xl font-bold">{goal.title}</h3>
                          <p className="text-sm text-muted-foreground">{goal.type}</p>
                        </div>
                        <div className="text-right">
                          <span className="text-2xl font-bold">{goal.current}</span>
                          <span className="text-muted-foreground"> / {goal.target} {goal.unit}</span>
                          <div className="flex items-center gap-1 text-xs text-muted-foreground mt-1 justify-end">
                            <Calendar className="w-3 h-3" /> Due {goal.deadline}
                          </div>
                        </div>
                      </div>
                      <Progress value={(goal.current / goal.target) * 100} className="h-3 bg-muted group-hover:ring-1 ring-primary/20 transition-all" />
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>

        <Card className="border-dashed border-border bg-transparent">
          <CardHeader>
            <CardTitle className="text-center text-muted-foreground">Vision Board</CardTitle>
          </CardHeader>
          <CardContent>
             <p className="text-center text-sm italic text-muted-foreground">"I will be a black belt within 5 years. I will master the art of discipline and focus."</p>
          </CardContent>
        </Card>
      </main>
    </div>
  );
}
